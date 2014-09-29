<?php

class Users extends Eloquent {

  protected $table = 'users';

  protected $hidden = array('password', 'id','notes','group');

  public $timestamps = false;
}

