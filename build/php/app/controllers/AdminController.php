<?php

class AdminController extends BaseController {

  // public function insertusers() {
  //   $users = array(
  //     array('username' => 'marcin.walaszek',        'password' => Hash::make('g94jd8'), 'group' => '3'),
  //     array('username' => 'daniel.solarz',          'password' => Hash::make('j4ufbs'), 'group' => '3'),
  //     array('username' => 'piotr.wiecek',           'password' => Hash::make('k49rjd'), 'group' => '3'),
  //     array('username' => 'bartlomiej.trzewiczek',  'password' => Hash::make('d94jtu'), 'group' => '3'),
  //     array('username' => 'bartlomiej.wojcieszek',  'password' => Hash::make('dne94h'), 'group' => '3'),
  //     array('username' => 'kalina.zajac',           'password' => Hash::make('dj59fv'), 'group' => '3'),
  //     array('username' => 'bartlomiej.tybor',       'password' => Hash::make('dp40rj'), 'group' => '3'),
  //     array('username' => 'arek.salawa',            'password' => Hash::make('vm5idu'), 'group' => '3'),
  //     array('username' => 'piotr.soltysiak',        'password' => Hash::make('dk49yg'), 'group' => '3'),
  //     array('username' => 'pawel.soltysiak',        'password' => Hash::make('v84nfm'), 'group' => '3'),
  //     array('username' => 'krzysztof.skowronek',    'password' => Hash::make('s84hfb'), 'group' => '3'),
  //     array('username' => 'piotr.sarna',            'password' => Hash::make('d3otmb'), 'group' => '3'),
  //     array('username' => 'monika.talach',          'password' => Hash::make('3nfjuv'), 'group' => '3'),
  //     array('username' => 'karolina.zenek',         'password' => Hash::make('49fjvs'), 'group' => '3'),
  //     array('username' => 'mateusz.smet',           'password' => Hash::make('d84jgb'), 'group' => '3'),
  //     array('username' => 'piotr.zurek',            'password' => Hash::make('b93kfu'), 'group' => '3'),
  //     array('username' => 'mateusz.pietruch',       'password' => Hash::make('soem40'), 'group' => '3'),
  //     array('username' => 'bartlomiej.wojnar',      'password' => Hash::make('vj3mdk'), 'group' => '3'),
  //     array('username' => 'bartosz.szewczyk',       'password' => Hash::make('9dk4mf'), 'group' => '3'),
  //     array('username' => 'zofia.tytula',           'password' => Hash::make('v84jsm'), 'group' => '3'),
  //     array('username' => 'dawid.trapp',            'password' => Hash::make('v93mdo'), 'group' => '3'),
  //     array('username' => 'stanislaw.slodyczka',    'password' => Hash::make('20doqh'), 'group' => '3'),
  //   );
  //   DB::table('users')->insert($users);
  //   return "Udało się!";
  // }

  public function userlist() {
    $userlist = DB::table('users')->where('admin','=','0')->select('username','id')->get();
    return Response::json(array('success'=>array('userlist'=>$userlist)));
  }

  public function edituser() {
    $requestedUserId = Input::get('requestedUser');
    $user = DB::table('users')->where('id','=',$requestedUserId)->select('username','id','group','notes')->first();
    $user['choices'] = DB::table('choices')->where('users_id','=',$requestedUserId)->get();

    return Response::json(array(
      'success'=>array(
        'calendar' => $this->getCalendar(),
        'requestedUser' => $user,
        //          'query' => DB::getQueryLog(),
        //          'items' => $data,
      )));
  }

  public function edituserpassword() {
    $user = Input::get('user');
    DB::table('users')->where('id', '=', $user['id'])->update(array(
      'password' => Hash::make($user['newPassword'])
    ));
    return Response::json(array(
      'success' => true
    ));
  }


  public function editsave() {
    $data = Input::get('events');
    $userId = Input::get('userId');
    $oldChoices = DB::table('choices')->where('users_id','=',$userId)->get();
    $toDelete = array();
    foreach($oldChoices as &$oldChoice) {
      $presentInRequestData = false;
      foreach($data as &$item) {
        if ($oldChoice['events_id'] == $item['events_id']) {
          $presentInRequestData = true;
          $item['omit'] = true;
          break;
        }
      }
      if ($presentInRequestData == false)
        $toDelete[] = $oldChoice['events_id'];
    }
    $toInsert = array();
    foreach($data as &$item) {
      if (!isset($item['omit'])) {
        $toInsert[] = $item;
      }
    }
    if (sizeof($toDelete) > 0)
      DB::table('choices')->whereIn('events_id',$toDelete)->where('users_id','=',$userId)->delete();
    if (sizeof($toInsert) > 0)
      DB::table('choices')->insert($toInsert);


    $user = DB::table('users')->where('id','=',$userId)->select('username','id','group','notes')->first();
    $user['choices'] = DB::table('choices')->where('users_id','=',$userId)->get();
    return Response::json(array(
      'success'=>array(
        'calendar' => $this->getCalendar(),
        'user' => $user,
        //          'query' => DB::getQueryLog(),
        //          'items' => $data,
      )));
  }

}