<?php

class LoginController extends BaseController {

  public function isLogged() {
    if (Auth::check()) {
      return Response::json(array('success' => array('user' => $this->getUser())));
    } else {
      return Response::json(array('error' => ''));
    }
  }

  public function tryToLogin() {
    $login = Input::get('login');
    if ($login) {
      if (Auth::attempt($login)) {
        return Response::json(array('success' =>array('user' => $this->getUser())));
      } else {
        return Response::json(array('error' => 'Nie ma takiego użytkownika, bądź hasło jest nieprawidłowe'));
      }
    } else {
      return Response::json(array('error' => 'Nie podano żadnych danych'));
    }
  }


  public function logout() {
    Auth::logout();
    return Response::json(array('success' => true));
  }

  public function register() {
    $data = Input::get('login');
    $newUser = new AuthUser();
    $newUser->username = $data['username'];
    $newUser->password = Hash::make($data['password']);
    $newUser->notes = $data['notes'];
    $newUser->anonymous = (int)$data['anonymous'];
    $newUser->group = $data['group'];
    $newUser->save();
    return Response::json(array('success' => true));
  }

  public function edit() {
    $data = Input::get('login');
    $editUser = Auth::user();
    if (Hash::check($data['password'], $editUser->password)) {
      if (isset($data['newPassword']))
        $editUser->password = Hash::make($data['newPassword']);
      $editUser->notes = $data['notes'];
      $editUser->anonymous = (int)$data['anonymous'];
      $editUser->save();
      return Response::json(array('success' => array(
        'user' => $this->getUser(),
        'calendar' => $this->getCalendar()
      )));
    } else {
      return Response::json(array('error' => 'Błędne hasło'));
    }
  }

}