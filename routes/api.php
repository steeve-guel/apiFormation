<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

use App\Http\Controllers\BookController;
use App\Http\Controllers\EnfantController;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::resource('books',BookController::class);

Route::prefix('enfants')-> controller(EnfantController::class)->group(function(){
    // Route::apiResource('/')->parameters(['' => 'enfant']);

    Route::get('/','index');
    Route::post('/add','store');
     Route::put('/{enfant}/enfant', 'update');
});
