<?php

class AuthUser extends Eloquent implements \Illuminate\Auth\UserInterface {

	protected $table = 'users';

  protected $primaryKey = 'username';

	protected $hidden = array('password');

  public $timestamps = false;


  public function getAuthIdentifier() {
    return $this->username;
  }

  public function getAuthPassword() {
    return $this->password;
  }

}
