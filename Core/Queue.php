<?php
namespace Core;

class Queue
{
    /**
     * Push a new job onto the queue.
     *
     * @param string $jobClass Fully qualified class name of the job
     * @param array $payload Data to pass to the job's handle method
     * @return int The ID of the created job
     */
    public static function push(string $jobClass, array $payload = [])
    {
        $db = Database::getInstance()->getConnection();

        $stmt = $db->prepare("INSERT INTO jobs (job_class, payload, status, created_at) VALUES (?, ?, 'pending', NOW())");
        $stmt->execute([$jobClass, json_encode($payload)]);

        return $db->lastInsertId();
    }
}
