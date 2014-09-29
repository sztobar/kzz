<?php

class Classes extends Eloquent {

  protected $table = 'classes';

  public $timestamps = false;

  public function types() {
    return $this->belongsTo('Types','types_id');
  }
}

