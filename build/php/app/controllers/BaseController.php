<?php

class BaseController extends Controller {

  protected function getCalendar() {
    $events = Events::with('classes')->with('classes.types')->with('choices')->with(array('choices.users' => function($query) {
//        if (Auth::user()->admin !== 1)
//          $query->where('anonymous','=','0');
      }))->get()->toArray();
    return $events;
  }

  protected function getUser() {
    $user =  Auth::user()->toArray();
    $user['choices'] = DB::table('choices')->where('users_id','=',$user['id'])->get();
    return $user;
  }

}