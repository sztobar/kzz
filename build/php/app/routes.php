<?php

Route::get('/calendar', 'CalendarController@query');
Route::post('/save', 'CalendarController@save');

Route::post('/login', 'LoginController@tryToLogin');
Route::get('/islogged', 'LoginController@isLogged');
Route::get('/logout', 'LoginController@logout');

Route::post('/register', 'LoginController@register');
Route::post('/edit', 'LoginController@edit');

Route::get('/userlist', array('before' => 'admin', 'uses' => 'AdminController@userlist'));
Route::post('/edituser', array('before' => 'admin', 'uses' => 'AdminController@edituser'));
Route::post('/editsave', array('before' => 'admin', 'uses' => 'AdminController@editsave'));
Route::post('/edituserpassword', array('before' => 'admin', 'uses' => 'AdminController@edituserpassword'));
//Route::get('/insert/users', array('before' => 'admin', 'uses' => 'AdminController@insertusers'));