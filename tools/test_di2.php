<?php
require 'Core/Container.php';
class B {}
class A {
    public function __construct(B $b) {}
}

$c = new \Core\Container();
$a = $c->build('A');
if ($a instanceof A) {
    echo "Resolves fine!";
}
