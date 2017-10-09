<?php

namespace AppBundle\Controller;

use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;

class DefaultController extends Controller
{
    /**
     * @Route("/synfo help", name="homepage")
     */
    public function synfoHelpAction(Request $request)
    {
        // replace this example code with whatever you need
        return $this->render('default/help.html.twig', [
            'base_dir' => realpath($this->container->getParameter('kernel.root_dir').'/..').DIRECTORY_SEPARATOR,
        ]);
    }

    /** @Route("/") */
    public function indexAction()
    { return $this->render('default/index.html.twig'); }
}
