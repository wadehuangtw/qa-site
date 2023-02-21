<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class QuestionController extends Controller
{
    public function show(Request $request, $categories)
    {
        $categories = explode('/', $categories);
        dd($categories);
    }
}
