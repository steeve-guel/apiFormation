<?php

namespace App\Http\Controllers;

use App\Models\Book;
use Illuminate\Http\Request;

class BookController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
        return Book::select('id','name','price','description')->get();
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        //
        $request->validate(([
            'name'=>'required',
            'price'=>'required',
            'description'=>'required',
        ]));

        Book::create($request->post());

        return response()->json(([
            'message' => 'new item added successfully'
        ]));
    }

    /**
     * Display the specified resource.
     */
    public function show(Book $book)
    {
        //
        return response()->json(([
            'book' => $book
        ]));
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Book $book)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Book $book)
    {
        //
        $request->validate(([
            'name'=>'required',
            'price'=>'required',
            'description'=>'required',
        ]));
        $book->fill($request->post())->update();

        return response()->json(([
            'message' => 'new item updated successfully'
        ]));
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Book $book)
    {
        //
        $book->delete();

        return response()->json(([
            'message' => 'new item deleted successfully'
        ]));
    }
}
