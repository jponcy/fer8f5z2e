<?php

namespace AppBundle\DataFixtures\ORM;

use Doctrine\Bundle\FixturesBundle\Fixture;
use Doctrine\Common\Persistence\ObjectManager;

/**
 *
 */
class LoadTaskData extends Fixture
{

    const LIMIT = 10;

    /** {@inheritDoc} */
    public function load(ObjectManager $manager)
    {
        for ($i = 0; $i < self::LIMIT; ++ $i) {
            $o = new \AppBundle\Entity\Task();

            if ($i % 4 == 0) {
                $o->setClosedAt(new \DateTime('today'));
                $o->setLabel(sprintf('Task n°%d', $i));

                $manager->persist($o);
            }
        }

        $manager->flush();
    }
}
