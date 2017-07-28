<?php

namespace ${NAMESPACE}\Tests\Browser;

use Tests\DuskTestCase;
use Laravel\Dusk\Browser;
use Illuminate\Foundation\Testing\DatabaseMigrations;

class ${CLASS}Test extends DuskTestCase
{
    /**
     * A basic browser test example.
     *
     * @return void
     */
    public function test${methodName}()
    {
        \$this->browse(function (Browser \$browser) {
            \$browser->visit('/backend');
        });
    }
}
