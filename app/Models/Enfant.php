<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Enfant extends Model
{
    //
    use HasFactory;

    protected $fillable = [
        'nom',
        'prenom',
        'sexe',
        'classe',
        'dateNaissance',
        'tHandicapV',
        'nomParent',
        'prenomParent',
        'contactParentBio',
        'observation'
    ];
}
