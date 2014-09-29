<?php

class CalendarController extends BaseController {

  public function query() {
    $events = $this->getCalendar();
    return Response::json(array('success' => array('calendar' => $events)));
  }

  public function save() {
    $limit = DB::table('limit')->get();
    if ($limit[0]['limit'] == 1)
      return Response::json(array('error' => 'termin zapisywania zajęć minął'));
    if (Auth::check()) {
      $user = Auth::user()->toArray();
      $userId = $user['id'];
      $data = Input::get('events');
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
      return Response::json(array(
        'success'=>array(
          'calendar' => $this->getCalendar(),
          'user' => $this->getUser(),
//          'query' => DB::getQueryLog(),
//          'items' => $data,
      )));
    } else {
      return Response::json(array('error' => 'Niezalogowany użytkownik'));
    }
  }
}