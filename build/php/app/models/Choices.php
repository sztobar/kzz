<?php

class Choices extends Eloquent {

  protected $table = 'choices';

  protected $hidden = array('users_id');

  public $timestamps = false;

  public function users() {
    return $this->belongsTo('Users','users_id');
  }
}

