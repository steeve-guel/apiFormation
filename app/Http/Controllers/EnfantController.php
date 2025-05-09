<?php

namespace App\Http\Controllers;

use App\Http\Requests\EnfantRequest;
use App\Models\Enfant;
use Illuminate\Http\Request;

class EnfantController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
        return Enfant::all();
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
    public function store(EnfantRequest $request)
    {
        //
        Enfant::create($request->validated());

        return response()->json((['message'=>'Données enregistrées avec succès!']));
    }

    /**
     * Display the specified resource.
     */
    public function show(Enfant $enfant)
    {
        //
        return response()->json((['enfant'=>$enfant]));
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Enfant $enfant)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(EnfantRequest $request, Enfant $enfant)
    {
        //
        $enfant->update($request->validated());

        return response()->json((['message'=>'Mise à jour effectuée avec succès!']));
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Enfant $enfant)
    {
        //
        $enfant->delete();

        return response()->json((['message'=>'Suppression effectuée avec succès!']));
    }
}
