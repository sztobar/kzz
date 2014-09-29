<?php

class Events extends Eloquent {

  protected $table = 'events';

  public $timestamps = false;


  public function classes() {
    return $this->belongsTo('Classes','classes_id');
  }

  public function choices() {
    return $this->hasMany('Choices', 'events_id');
  }
}

