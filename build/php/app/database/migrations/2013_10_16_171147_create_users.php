<?php

use Illuminate\Database\Migrations\Migration;

class CreateUsers extends Migration {

	/**
	 * Run the migrations.
	 *
	 * @return void
	 */
	public function up()
	{
    Schema::create('Uzytkownicy', function($table) {
      $table->engine = 'InnoDB';

      $table->increments('id');
      $table->string('login',30);
      $table->string('haslo',40);
      $table->boolean('administrator')->default(0);
      $table->boolean('dozwolone_ip')->default(0);
    });
	}

	/**
	 * Reverse the migrations.
	 *
	 * @return void
	 */
	public function down()
	{
    Schema::drop('Uzytkownicy');
	}

}
