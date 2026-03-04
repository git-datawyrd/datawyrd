<?php
namespace Core;

use Exception;
use ReflectionClass;
use ReflectionMethod;
use ReflectionParameter;

/**
 * Simple Dependency Injection Container
 */
class Container
{
    private array $instances = [];
    private array $bindings = [];

    /**
     * Bind a class or interface to a resolver.
     */
    public function bind(string $abstract, $concrete = null, bool $shared = false): void
    {
        if ($concrete === null) {
            $concrete = $abstract;
        }
        $this->bindings[$abstract] = [
            'concrete' => $concrete,
            'shared' => $shared
        ];
    }

    /**
     * Register a singleton binding.
     */
    public function singleton(string $abstract, $concrete = null): void
    {
        $this->bind($abstract, $concrete, true);
    }

    /**
     * Register an existing instance as a singleton.
     */
    public function instance(string $abstract, $instance): void
    {
        $this->instances[$abstract] = $instance;
    }

    /**
     * Resolve the given type from the container.
     */
    public function get(string $abstract)
    {
        // 1. Check if we already have a shared instance
        if (isset($this->instances[$abstract])) {
            return $this->instances[$abstract];
        }

        // 2. Get the concrete implementation and sharing status
        $concrete = $this->bindings[$abstract]['concrete'] ?? $abstract;
        $shared = $this->bindings[$abstract]['shared'] ?? false;

        // 3. Resolve the object
        if ($concrete instanceof \Closure) {
            $object = $concrete($this);
        } else {
            $object = $this->build($concrete);
        }

        // 4. Store if shared
        if ($shared) {
            $this->instances[$abstract] = $object;
        }

        return $object;
    }

    /**
     * Build an instance of the given class.
     */
    public function build(string $concrete)
    {
        $reflection = new ReflectionClass($concrete);

        if (!$reflection->isInstantiable()) {
            throw new Exception("Class {$concrete} is not instantiable.");
        }

        $constructor = $reflection->getConstructor();

        if (null === $constructor) {
            return new $concrete;
        }

        $parameters = $constructor->getParameters();
        $dependencies = $this->resolveDependencies($parameters);

        return $reflection->newInstanceArgs($dependencies);
    }

    /**
     * Resolve dependencies for parameters.
     */
    private function resolveDependencies(array $parameters): array
    {
        $dependencies = [];

        foreach ($parameters as $parameter) {
            $type = $parameter->getType();

            if ($type instanceof \ReflectionNamedType && !$type->isBuiltin()) {
                $dependencies[] = $this->get($type->getName());
            } elseif ($parameter->isDefaultValueAvailable()) {
                $dependencies[] = $parameter->getDefaultValue();
            } else {
                throw new Exception("Cannot resolve parameter {$parameter->getName()}");
            }
        }

        return $dependencies;
    }

    /**
     * Resolve a method with dependencies.
     */
    public function call($instance, string $method, array $extraParams = [])
    {
        $reflection = new ReflectionMethod($instance, $method);
        $parameters = $reflection->getParameters();
        $dependencies = [];

        $positionalIndex = 0;

        foreach ($parameters as $parameter) {
            $name = $parameter->getName();
            $type = $parameter->getType();

            // 1. Variadic parameter (...$params)
            if ($parameter->isVariadic()) {
                // Collect all remaining extraParams from current positionalIndex
                $remaining = array_slice($extraParams, $positionalIndex);
                // If extraParams is associative but we are at the end, this still works
                // variadic must be an array of arguments
                $dependencies = array_merge($dependencies, $remaining);
                break; // Variadic must be the last parameter
            }

            // 2. Match by Class/Type hint (Dependency Injection)
            if ($type instanceof \ReflectionNamedType && !$type->isBuiltin()) {
                $dependencies[] = $this->get($type->getName());
            }
            // 3. Match by Name (associative array)
            elseif (array_key_exists($name, $extraParams)) {
                $dependencies[] = $extraParams[$name];
            }
            // 4. Match by Position (for URL parameters like $slug)
            elseif (array_key_exists($positionalIndex, $extraParams)) {
                $dependencies[] = $extraParams[$positionalIndex];
                $positionalIndex++;
            }
            // 5. Default Value
            elseif ($parameter->isDefaultValueAvailable()) {
                $dependencies[] = $parameter->getDefaultValue();
            } else {
                throw new Exception("Cannot resolve parameter {$name} for method {$method}");
            }
        }

        return $reflection->invokeArgs($instance, $dependencies);
    }
}
