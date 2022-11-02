# frozen_string_literal: true

class InitializeGoldberg < ActiveRecord::Migration[4.2]
  def self.up
    create_table 'goldberg_permissions', force: true do |t|
      t.column 'name', :string, default: '', null: false
    end
    execute "INSERT INTO `goldberg_permissions` VALUES (1,'Administer site'),(2,'Public pages - edit'),(3,'Public pages - view'),(4,'Public actions - execute'),(5,'Members only page -- view');"

    create_table 'goldberg_markup_styles', force: true do |t|
      t.column 'name', :string, default: '', null: false
    end

    create_table 'goldberg_content_pages', force: true do |t|
      t.column 'title', :string
      t.column 'name', :string, default: '', null: false
      t.column 'markup_style_id', :integer
      t.column 'content', :text
      t.column 'permission_id', :integer, default: 0, null: false
      t.column 'created_at', :datetime
      t.column 'updated_at', :datetime
      t.column 'content_cache', :text
      t.column 'markup_style', :string
    end

    add_index 'goldberg_content_pages', ['permission_id'], name: 'fk_content_page_permission_id'
    add_index 'goldberg_content_pages', ['markup_style_id'], name: 'fk_content_page_markup_style_id'

    execute "INSERT INTO `goldberg_content_pages` VALUES (1,'Home Page','home',1,'h1. Welcome to Goldberg!\n\nLooks like you have succeeded in getting Goldberg up and running.  Now you will probably want to customize your site.\n\n*Very important:* The default login for the administrator is \"admin\", password \"admin\".  You must change that before you make your site public!\n\nh2. Administering the Site\n\nAt the login prompt, enter an administrator username and password.  The top menu should change: a new item called \"Administration\" will appear.  Go there for further details.\n',3,'2006-06-12 00:31:56','2007-05-21 14:01:58','<h1>Welcome to Goldberg!</h1>\n\n\n  <p>Looks like you have succeeded in getting Goldberg up and running.  Now you will probably want to customise your site.</p>\n\n\n  <p><strong>Very important:</strong> The default login for the administrator is &#8220;admin&#8221;, password &#8220;admin&#8221;.  You must change that before you make your site public!</p>\n\n\n <h2>Administering the Site</h2>\n\n\n <p>At the login prompt, enter an administrator username and password.  The top menu should change: a new item called &#8220;Administration&#8221; will appear.  Go there for further details.</p>','Textile');"
    execute "INSERT INTO `goldberg_content_pages` VALUES (2,'Session Expired','expired',1,'h1. Session Expired\n\nYour session has expired due to inactivity.\n\nTo continue please login again.\n',3,'2006-06-12 00:33:14','2007-05-21 14:01:58','<h1>Session Expired</h1>\n\n\n  <p>Your session has expired due to inactivity.</p>\n\n\n  <p>To continue please login again.</p>','Textile');"
    execute "INSERT INTO `goldberg_content_pages` VALUES (3,'Not Found!','notfound',1,'h1. Not Found\n\nThe page you requested was not found!\n\nPlease contact your system administrator.',3,'2006-06-12 00:33:49','2007-05-21 14:01:59','<h1>Not Found</h1>\n\n\n <p>The page you requested was not found!</p>\n\n\n  <p>Please contact your system administrator.</p>','Textile');"
    execute "INSERT INTO `goldberg_content_pages` VALUES (4,'Permission Denied!','denied',1,'h1. Permission Denied\n\nSorry, but you don''t have permission to view that page.\n\nPlease contact your system administrator.',3,'2006-06-12 00:34:30','2007-05-21 14:01:59','<h1>Permission Denied</h1>\n\n\n  <p>Sorry, but you don&#8217;t have permission to view that page.</p>\n\n\n  <p>Please contact your system administrator.</p>','Textile');"
    execute "INSERT INTO `goldberg_content_pages` VALUES (6,'Contact Us', 'contact_us', 1, 'h1. Contact Us\n\nVisit the Goldberg Project Homepage at \"http://goldberg.rubyforge.org\":http://goldberg.rubyforge.org for further information on Goldberg. Visit the Goldberg RubyForge Project Info Page at \"http://rubyforge.org/projects/goldberg\":http://rubyforge.org/projects/goldberg to access the project''s files and development information.', 3, '2006-06-12 10:13:47', '2007-05-21 14:01:59', '<h1>Contact Us</h1>\n\n\n <p>Visit the Goldberg Project Homepage at <a href=\"http://goldberg.rubyforge.org\">http://goldberg.rubyforge.org</a> for further information on Goldberg. Visit the Goldberg RubyForge Project Info Page at <a href=\"http://rubyforge.org/projects/goldberg\">http://rubyforge.org/projects/goldberg</a> to access the project&#8217;s files and development information.</p>', 'Textile' );"
    execute "INSERT INTO `goldberg_content_pages` VALUES (8,'Site Administration','site_admin',1,'h1. Goldberg Setup\n\nThis is where you will find all the Goldberg-specific administration and configuration features.  In here you can:\n\n* Set up Users.\n\n* Manage Roles and their Permissions.\n\n* Set up any Controllers and their Actions for your application.\n\n* Edit the Content Pages of the site.\n\n* Adjust Goldberg''s system settings.\n\n\nh2. Users\n\nYou can set up Users with a username, password and a Role.\n\n\nh2. Roles and Permissions\n\nA User''s Permissions affect what Actions they can perform and what Pages they can see.  And because each Menu Item is based either on a Page or an Action, the Permissions determine what Menu Items the User can and cannot see.\n\nA Role is a set of Permissions.  Roles are assigned to Users.  Roles are hierarchical: a Role can have a parent Role; and if so it will inherit the Permissions of the parent Role, and all its parents.\n\n\nh2. Controllers and Actions\n\nTo execute any Action, a user must have the appropriate Permission.  Therefore all Controllers and Actions you set up for your Rails application need to be entered here, otherwise no user will be able to execute them.\n\nYou start by setting up the Controller and assigning it a Permission.  The Permission will be used as the default for any Actions invoked for that Controller.\n\nYou have the option of setting up specific Actions for the Controllers.  You would want to do that if the Action were to appear as a Menu Item, or if it were to have a different level of security to the default for the Controller.\n\n\nh2. Content Pages\n\nGoldberg has a very simple CMS built in.  You can create pages to be displayed on the site, possibly in menu items.\n\n\nh2. Menu Editor\n\nOnce you have set up your Controller Actions and Content Pages, you can put them into the site''s menu using the Menu Editor.\n\n In the Menu Editor you can add and remove Menu Items and move them around.  The security of a Menu Item (whether the user can see it or not) depends on the Permission of the Action or Page attached to that Menu Item.\n\nh2. System Settings\n\nGo here to view and edit the settings that determine how Goldberg operates.\n',1,'2006-06-21 21:32:35','2007-05-21 14:01:59','<h1>Goldberg Setup</h1>\n\n\n  <p>This is where you will find all the Goldberg-specific administration and configuration features.  In here you can:</p>\n\n\n <ul>\n  <li>Set up Users.</li>\n  </ul>\n\n\n <ul>\n  <li>Manage Roles and their Permissions.</li>\n  </ul>\n\n\n <ul>\n  <li>Set up any Controllers and their Actions for your application.</li>\n </ul>\n\n\n <ul>\n  <li>Edit the Content Pages of the site.</li>\n  </ul>\n\n\n <ul>\n  <li>Adjust Goldberg&#8217;s system settings.</li>\n </ul>\n\n\n <h2>Users</h2>\n\n\n  <p>You can set up Users with a username, password and a Role.</p>\n\n\n <h2>Roles and Permissions</h2>\n\n\n  <p>A User&#8217;s Permissions affect what Actions they can perform and what Pages they can see.  And because each Menu Item is based either on a Page or an Action, the Permissions determine what Menu Items the User can and cannot see.</p>\n\n\n  <p>A Role is a set of Permissions.  Roles are assigned to Users.  Roles are hierarchical: a Role can have a parent Role; and if so it will inherit the Permissions of the parent Role, and all its parents.</p>\n\n\n <h2>Controllers and Actions</h2>\n\n\n  <p>To execute any Action, a user must have the appropriate Permission.  Therefore all Controllers and Actions you set up for your Rails application need to be entered here, otherwise no user will be able to execute them.</p>\n\n\n  <p>You start by setting up the Controller and assigning it a Permission.  The Permission will be used as the default for any Actions invoked for that Controller.</p>\n\n\n <p>You have the option of setting up specific Actions for the Controllers.  You would want to do that if the Action were to appear as a Menu Item, or if it were to have a different level of security to the default for the Controller.</p>\n\n\n <h2>Content Pages</h2>\n\n\n  <p>Goldberg has a very simple <span class=\"caps\">CMS</span> built in.  You can create pages to be displayed on the site, possibly in menu items.</p>\n\n\n  <h2>Menu Editor</h2>\n\n\n  <p>Once you have set up your Controller Actions and Content Pages, you can put them into the site&#8217;s menu using the Menu Editor.</p>\n\n\n <p>In the Menu Editor you can add and remove Menu Items and move them around.  The security of a Menu Item (whether the user can see it or not) depends on the Permission of the Action or Page attached to that Menu Item.</p>\n\n\n <h2>System Settings</h2>\n\n\n  <p>Go here to view and edit the settings that determine how Goldberg operates.</p>','Textile');"
    execute "INSERT INTO `goldberg_content_pages` VALUES (9,'Administration','admin',1,'h1. Site Administration\n\nThis is where the administrator can set up the site.\n\nThere is one menu item here by default -- \"Setup\":/menu/setup.  That contains all the Goldberg configuration options.\n\nYou can add more menu items here to administer your application if you want, by going to \"Setup, Menu Editor\":/menu/setup/menus.\n',1,'2006-06-26 16:47:09','2007-05-21 14:01:59','<h1>Site Administration</h1>\n\n\n <p>This is where the administrator can set up the site.</p>\n\n\n <p>There is one menu item here by default&#8212;<a href=\"/menu/setup\">Setup</a>.  That contains all the Goldberg configuration options.</p>\n\n\n <p>You can add more menu items here to administer your application if you want, by going to <a href=\"/menu/setup/menus\">Setup, Menu Editor</a>.</p>','Textile');"
    execute "INSERT INTO `goldberg_content_pages` VALUES (10,'Credits and Licence','credits',1,'h1. Credits and Licence\n\nGoldberg contains original material and third party material from various sources.\n\nAll original material is (p) Public Domain, No Rights Reserved.  Goldberg comes with no warranty whatsoever.\n\nThe copyright for any third party material remains with the original author, and the material is distributed here under the original terms.  \n\nMaterial has been selected from sources with licensing terms and conditions that allow use and redistribution for both personal and business purposes.  These licences include public domain, BSD-style licences, and Creative Commons licences (but *not* Creative Commons Non-Commercial).\n\nIf you are an author and you believe your copyrighted material has been included in Goldberg in breach of your licensing terms and conditions, please contact Dave Nelson (urbanus at 240gl dot org).\n\n\nh2. Layouts\n\nGoldberg comes with a choice of layouts, adapted from various sources.\n\nh3. The Default\n\nThe default layout is a modified version of Andreas09 by Anreas Viklund.  Andreas09 is distributed under free/unlicensed terms, with an informal request that credit be given to the original author.  The original template can be obtained from \"Open Source Web Design\":http://www.oswd.org/design/preview/id/2493/.\n\nAuthor''s website: \"andreasviklund.com\":http://andreasviklund.com/.\n\n\nh3. \"Earth Wind and Fire\"\n\nOriginally designed by Brett Hillesheim (brett7481 at msn dot com) and distributed under free terms (from the MadSeason website: \"Every template we create is completely open source, meaning you can take it and do whatever you want with it\").  The original template can be obtained from \"Open Source Web Design\":http://www.oswd.org/design/preview/id/2453/.\n\nAuthor''s website: \"www.madseason.co.uk\":http://www.madseason.co.uk/.\n\n\nh3. \"Snooker\"\n\n\"Snooker\" is an original design and is therefore Public Domain.  It incorporates dynamic two-column layout techniques described on the \"A List Apart\":http://alistapart.com/articles/negativemargins website.\n\n\nh3. \"Spoiled Brat\"\n\nOriginally designed by \"Rayk Web Design\":http://www.raykdesign.net/ and distributed under the terms of the \"Creative Commons Attribution Share Alike\":http://creativecommons.org/licenses/by-sa/2.5/legalcode licence.  The original template can be obtained from \"Open Web Design\":http://www.openwebdesign.org/viewdesign.phtml?id=2894/.\n\nAuthor''s website: \"www.csstinderbox.com\":http://www.csstinderbox.com/.\n\n\nh2. Other Features\n\nGoldberg also contains some miscellaneous code and techniques from other sources.\n\nh3. Suckerfish Menus\n\nThe three templates \"Earth Wind and Fire\", \"Snooker\" and \"Spoiled Brat\" have all been configured to use Suckerfish menus.  This technique of using a combination of CSS and Javascript to implement dynamic menus was first described by \"A List Apart\":http://www.alistapart.com/articles/dropdowns/.  Goldberg''s implementation also incorporates techniques described by \"HTMLDog\":http://www.htmldog.com/articles/suckerfish/dropdowns/.\n\nh3. Tabbed Panels\n\nGoldberg''s implementation of tabbed panels was adapted from \n\"InternetConnection\":http://support.internetconnection.net/CODE_LIBRARY/Javascript_Show_Hide.shtml.\n',3,'2006-10-02 10:35:35','2007-05-21 14:01:59','<h1>Credits and Licence</h1>\n\n\n  <p>Goldberg contains original material and third party material from various sources.</p>\n\n\n <p>All original material is (p) Public Domain, No Rights Reserved.  Goldberg comes with no warranty whatsoever.</p>\n\n\n <p>The copyright for any third party material remains with the original author, and the material is distributed here under the original terms.</p>\n\n\n  <p>Material has been selected from sources with licensing terms and conditions that allow use and redistribution for both personal and business purposes.  These licences include public domain, <span class=\"caps\">BSD</span>-style licences, and Creative Commons licences (but <strong>not</strong> Creative Commons Non-Commercial).</p>\n\n\n  <p>If you are an author and you believe your copyrighted material has been included in Goldberg in breach of your licensing terms and conditions, please contact Dave Nelson (urbanus at 240gl dot org).</p>\n\n\n  <h2>Layouts</h2>\n\n\n  <p>Goldberg comes with a choice of layouts, adapted from various sources.</p>\n\n\n <h3>The Default</h3>\n\n\n  <p>The default layout is a modified version of Andreas09 by Anreas Viklund.  Andreas09 is distributed under free/unlicensed terms, with an informal request that credit be given to the original author.  The original template can be obtained from <a href=\"http://www.oswd.org/design/preview/id/2493/\">Open Source Web Design</a>.</p>\n\n\n  <p>Author&#8217;s website: <a href=\"http://andreasviklund.com/\">andreasviklund.com</a>.</p>\n\n\n <h3>&#8220;Earth Wind and Fire&#8221;</h3>\n\n\n  <p>Originally designed by Brett Hillesheim (brett7481 at msn dot com) and distributed under free terms (from the MadSeason website: &#8220;Every template we create is completely open source, meaning you can take it and do whatever you want with it&#8221;).  The original template can be obtained from <a href=\"http://www.oswd.org/design/preview/id/2453/\">Open Source Web Design</a>.</p>\n\n\n  <p>Author&#8217;s website: <a href=\"http://www.madseason.co.uk/\">www.madseason.co.uk</a>.</p>\n\n\n <h3>&#8220;Snooker&#8221;</h3>\n\n\n  <p>&#8220;Snooker&#8221; is an original design and is therefore Public Domain.  It incorporates dynamic two-column layout techniques described on the <a href=\"http://alistapart.com/articles/negativemargins\">A List Apart</a> website.</p>\n\n\n  <h3>&#8220;Spoiled Brat&#8221;</h3>\n\n\n <p>Originally designed by <a href=\"http://www.raykdesign.net/\">Rayk Web Design</a> and distributed under the terms of the <a href=\"http://creativecommons.org/licenses/by-sa/2.5/legalcode\">Creative Commons Attribution Share Alike</a> licence.  The original template can be obtained from <a href=\"http://www.openwebdesign.org/viewdesign.phtml?id=2894/\">Open Web Design</a>.</p>\n\n\n <p>Author&#8217;s website: <a href=\"http://www.csstinderbox.com/\">www.csstinderbox.com</a>.</p>\n\n\n <h2>Other Features</h2>\n\n\n <p>Goldberg also contains some miscellaneous code and techniques from other sources.</p>\n\n\n  <h3>Suckerfish Menus</h3>\n\n\n <p>The three templates &#8220;Earth Wind and Fire&#8221;, &#8220;Snooker&#8221; and &#8220;Spoiled Brat&#8221; have all been configured to use Suckerfish menus.  This technique of using a combination of <span class=\"caps\">CSS</span> and Javascript to implement dynamic menus was first described by <a href=\"http://www.alistapart.com/articles/dropdowns/\">A List Apart</a>.  Goldberg&#8217;s implementation also incorporates techniques described by <a href=\"http://www.htmldog.com/articles/suckerfish/dropdowns/\">HTMLDog</a>.</p>\n\n\n <h3>Tabbed Panels</h3>\n\n\n  <p>Goldberg&#8217;s implementation of tabbed panels was adapted from \n<a href=\"http://support.internetconnection.net/CODE_LIBRARY/Javascript_Show_Hide.shtml\">InternetConnection</a>.</p>','Textile');"
    execute "INSERT INTO `goldberg_content_pages` VALUES (11,'Not Permitted','unconfirmed',NULL,'h1. Not Permitted\n\nSorry, but you are not allowed to log into the site until your registration has been confirmed.\n\nIf there is an issue please contact the system administrator.\n',3,'2007-04-01 10:37:42','2007-05-21 14:01:59','<h1>Not Permitted</h1>\n\n\n <p>Sorry, but you are not allowed to log into the site until your registration has been confirmed.</p>\n\n\n  <p>If there is an issue please contact the system administrator.</p>','Textile');"

    create_table 'goldberg_site_controllers', force: true do |t|
      t.column 'name', :string, default: '', null: false
      t.column 'permission_id', :integer, default: 0, null: false
      t.column 'builtin', :integer, default: 0
    end

    add_index 'goldberg_site_controllers', ['permission_id'], name: 'fk_site_controller_permission_id'

    execute "INSERT INTO `goldberg_site_controllers` VALUES (1,'goldberg/content_pages',1,1),(2,'goldberg/controller_actions',1,1),(3,'goldberg/auth',1,1),(5,'goldberg/menu_items',1,1),(6,'goldberg/permissions',1,1),(7,'goldberg/roles',1,1),(8,'goldberg/site_controllers',1,1),(9,'goldberg/system_settings',1,1),(10,'goldberg/users',1,1),(11,'goldberg/roles_permissions',1,1);"

    create_table 'goldberg_controller_actions', force: true do |t|
      t.column 'site_controller_id', :integer, default: 0, null: false
      t.column 'name', :string, default: '', null: false
      t.column 'permission_id', :integer
      t.column 'url_to_use', :string
    end

    add_index 'goldberg_controller_actions', ['permission_id'], name: 'fk_controller_action_permission_id'
    add_index 'goldberg_controller_actions', ['site_controller_id'], name: 'fk_controller_action_site_controller_id'

    execute "INSERT INTO `goldberg_controller_actions` VALUES (1,1,'view_default',3,NULL),(2,1,'view',3,NULL),(3,7,'list',NULL,NULL),(4,6,'list',NULL,NULL),(5,3,'login',4,NULL),(6,3,'logout',4,NULL),(7,5,'link',4,NULL),(8,1,'list',NULL,NULL),(9,8,'list',NULL,NULL),(10,2,'list',NULL,NULL),(11,5,'list',NULL,NULL),(12,9,'list',NULL,NULL),(13,3,'forgotten',4,NULL),(14,3,'login_failed',4,NULL),(15,10,'list',NULL,NULL),(16,10,'self_register',4,''),(17,10,'confirm_registration',4,''),(18,10,'confirm_registration_submit',4,''),(19,10,'self_create',4,''),(20,10,'forgot_password',4,''),(21,10,'forgot_password_submit',4,''),(22,10,'reset_password',4,''),(23,10,'reset_password_submit',4,'');"

    create_table 'goldberg_menu_items', force: true do |t|
      t.column 'parent_id', :integer
      t.column 'name', :string, default: '', null: false
      t.column 'label', :string, default: '', null: false
      t.column 'seq', :integer
      t.column 'controller_action_id', :integer
      t.column 'content_page_id', :integer
    end

    add_index 'goldberg_menu_items', ['controller_action_id'], name: 'fk_menu_item_controller_action_id'
    add_index 'goldberg_menu_items', ['content_page_id'], name: 'fk_menu_item_content_page_id'
    add_index 'goldberg_menu_items', ['parent_id'], name: 'fk_menu_item_parent_id'

    execute "INSERT INTO `goldberg_menu_items` VALUES (1,NULL,'home','Home',1,NULL,1),(2,NULL,'contact_us','Contact Us',3,NULL,6),(3,NULL,'admin','Administration',2,NULL,9),(5,9,'setup/permissions','Permissions',3,4,NULL),(6,9,'setup/roles','Roles',2,3,NULL),(7,9,'setup/pages','Content Pages',5,8,NULL),(8,9,'setup/controllers','Controllers / Actions',4,9,NULL),(9,3,'setup','Setup',1,NULL,8),(11,9,'setup/menus','Menu Editor',6,11,NULL),(12,9,'setup/system_settings','System Settings',7,12,NULL),(13,9,'setup/users','Users',1,15,NULL),(14,2,'credits','Credits &amp; Licence',1,NULL,10);"

    create_table 'goldberg_roles', force: true do |t|
      t.column 'name', :string, default: '', null: false
      t.column 'parent_id', :integer
      t.column 'description', :string, default: '', null: false
      t.column 'default_page_id', :integer
      t.column 'cache', :text
      t.column 'created_at', :datetime
      t.column 'updated_at', :datetime
      t.column 'start_path', :string
    end

    add_index 'goldberg_roles', ['parent_id'], name: 'fk_role_parent_id'
    add_index 'goldberg_roles', ['default_page_id'], name: 'fk_role_default_page_id'

    execute "INSERT INTO `goldberg_roles` VALUES (1,'Public',NULL,'Members of the public who are not logged in.',NULL,'--- \n:credentials: !ruby/object:Goldberg::Credentials \n  actions: \n    goldberg/site_controllers: \n      list: false\n    goldberg/menu_items: \n      list: false\n      link: true\n    goldberg/roles: \n      list: false\n    goldberg/permissions: \n      list: false\n    goldberg/system_settings: \n      list: false\n    goldberg/content_pages: \n      list: false\n      view_default: true\n      view: true\n    goldberg/auth: \n      logout: true\n      forgotten: true\n      login_failed: true\n      login: true\n    goldberg/controller_actions: \n      list: false\n    goldberg/users: \n      self_register: true\n      list: false\n      forgot_password: true\n      forgot_password_submit: true\n      reset_password: true\n      reset_password_submit: true\n      confirm_registration: true\n      self_create: true\n      confirm_registration_submit: true\n  controllers: \n    goldberg/site_controllers: false\n    goldberg/roles_permissions: false\n    goldberg/menu_items: false\n    goldberg/permissions: false\n    goldberg/roles: false\n    goldberg/system_settings: false\n    goldberg/content_pages: false\n    goldberg/auth: false\n    goldberg/controller_actions: false\n    goldberg/users: false\n  pages: \n    notfound: true\n    admin: false\n    site_admin: false\n    unconfirmed: true\n    contact_us: true\n    credits: true\n    home: true\n    expired: true\n    denied: true\n  permission_ids: \n  - 4\n  - 3\n  role_id: 1\n  role_ids: \n  - 1\n  updated_at: 2007-03-31 20:37:43 -04:00\n:menu: !ruby/object:Goldberg::Menu \n  by_id: \n    1: &id003 !ruby/object:Goldberg::Menu::Node \n      content_page_id: 1\n      controller_action_id: \n      id: 1\n      label: Home\n      name: home\n      parent: \n      parent_id: \n      site_controller_id: \n      url: /home\n    2: &id001 !ruby/object:Goldberg::Menu::Node \n      children: \n      - 14\n      content_page_id: 6\n      controller_action_id: \n      id: 2\n      label: Contact Us\n      name: contact_us\n      parent: \n      parent_id: \n      site_controller_id: \n      url: /contact_us\n    14: &id002 !ruby/object:Goldberg::Menu::Node \n      content_page_id: 10\n      controller_action_id: \n      id: 14\n      label: Credits &amp; Licence\n      name: credits\n      parent: \n      parent_id: 2\n      site_controller_id: \n      url: /credits\n  by_name: \n    contact_us: *id001\n    credits: *id002\n    home: *id003\n  crumbs: \n  - 1\n  root: &id004 !ruby/object:Goldberg::Menu::Node \n    children: \n    - 1\n    - 2\n    parent: \n  selected: \n    1: *id003\n  vector: \n  - *id004\n  - *id003\n','2006-06-23 21:03:49','2007-05-21 14:02:01',NULL),(2,'Member',1,'',NULL,'--- \n:credentials: !ruby/object:Goldberg::Credentials \n  actions: \n    goldberg/site_controllers: \n      list: false\n    goldberg/menu_items: \n      list: false\n      link: true\n    goldberg/roles: \n      list: false\n    goldberg/permissions: \n      list: false\n    goldberg/system_settings: \n      list: false\n    goldberg/content_pages: \n      list: false\n      view_default: true\n      view: true\n    goldberg/auth: \n      logout: true\n      forgotten: true\n      login_failed: true\n      login: true\n    goldberg/controller_actions: \n      list: false\n    goldberg/users: \n      self_register: true\n      list: false\n      forgot_password: true\n      forgot_password_submit: true\n      reset_password: true\n      reset_password_submit: true\n      confirm_registration: true\n      self_create: true\n      confirm_registration_submit: true\n  controllers: \n    goldberg/site_controllers: false\n    goldberg/roles_permissions: false\n    goldberg/menu_items: false\n    goldberg/permissions: false\n    goldberg/roles: false\n    goldberg/system_settings: false\n    goldberg/content_pages: false\n    goldberg/auth: false\n    goldberg/controller_actions: false\n    goldberg/users: false\n  pages: \n    notfound: true\n    admin: false\n    site_admin: false\n    unconfirmed: true\n    contact_us: true\n    credits: true\n    home: true\n    expired: true\n    denied: true\n  permission_ids: \n  - 5\n  - 4\n  - 3\n  role_id: 2\n  role_ids: \n  - 2\n  - 1\n  updated_at: 2007-03-31 20:37:43 -04:00\n:menu: !ruby/object:Goldberg::Menu \n  by_id: \n    1: &id003 !ruby/object:Goldberg::Menu::Node \n      content_page_id: 1\n      controller_action_id: \n      id: 1\n      label: Home\n      name: home\n      parent: \n      parent_id: \n      site_controller_id: \n      url: /home\n    2: &id001 !ruby/object:Goldberg::Menu::Node \n      children: \n      - 14\n      content_page_id: 6\n      controller_action_id: \n      id: 2\n      label: Contact Us\n      name: contact_us\n      parent: \n      parent_id: \n      site_controller_id: \n      url: /contact_us\n    14: &id002 !ruby/object:Goldberg::Menu::Node \n      content_page_id: 10\n      controller_action_id: \n      id: 14\n      label: Credits &amp; Licence\n      name: credits\n      parent: \n      parent_id: 2\n      site_controller_id: \n      url: /credits\n  by_name: \n    contact_us: *id001\n    credits: *id002\n    home: *id003\n  crumbs: \n  - 1\n  root: &id004 !ruby/object:Goldberg::Menu::Node \n    children: \n    - 1\n    - 2\n    parent: \n  selected: \n    1: *id003\n  vector: \n  - *id004\n  - *id003\n','2006-06-23 21:03:50','2007-05-21 14:02:01',NULL),(3,'Administrator',2,'',8,'--- \n:credentials: !ruby/object:Goldberg::Credentials \n  actions: \n    goldberg/site_controllers: \n      list: true\n    goldberg/menu_items: \n      list: true\n      link: true\n    goldberg/roles: \n      list: true\n    goldberg/permissions: \n      list: true\n    goldberg/system_settings: \n      list: true\n    goldberg/content_pages: \n      list: true\n      view_default: true\n      view: true\n    goldberg/auth: \n      logout: true\n      forgotten: true\n      login_failed: true\n      login: true\n    goldberg/controller_actions: \n      list: true\n    goldberg/users: \n      self_register: true\n      list: true\n      forgot_password: true\n      forgot_password_submit: true\n      reset_password: true\n      reset_password_submit: true\n      confirm_registration: true\n      self_create: true\n      confirm_registration_submit: true\n  controllers: \n    goldberg/site_controllers: true\n    goldberg/roles_permissions: true\n    goldberg/menu_items: true\n    goldberg/permissions: true\n    goldberg/roles: true\n    goldberg/system_settings: true\n    goldberg/content_pages: true\n    goldberg/auth: true\n    goldberg/controller_actions: true\n    goldberg/users: true\n  pages: \n    notfound: true\n    admin: true\n    site_admin: true\n    unconfirmed: true\n    contact_us: true\n    credits: true\n    home: true\n    expired: true\n    denied: true\n  permission_ids: \n  - 1\n  - 5\n  - 4\n  - 2\n  - 3\n  role_id: 3\n  role_ids: \n  - 3\n  - 2\n  - 1\n  updated_at: 2007-03-31 20:37:43 -04:00\n:menu: !ruby/object:Goldberg::Menu \n  by_id: \n    5: &id009 !ruby/object:Goldberg::Menu::Node \n      content_page_id: \n      controller_action_id: 4\n      id: 5\n      label: Permissions\n      name: setup/permissions\n      parent: \n      parent_id: 9\n      site_controller_id: 6\n      url: /goldberg/permissions/list\n    11: &id004 !ruby/object:Goldberg::Menu::Node \n      content_page_id: \n      controller_action_id: 11\n      id: 11\n      label: Menu Editor\n      name: setup/menus\n      parent: \n      parent_id: 9\n      site_controller_id: 5\n      url: /goldberg/menu_items/list\n    6: &id006 !ruby/object:Goldberg::Menu::Node \n      content_page_id: \n      controller_action_id: 3\n      id: 6\n      label: Roles\n      name: setup/roles\n      parent: \n      parent_id: 9\n      site_controller_id: 7\n      url: /goldberg/roles/list\n    1: &id011 !ruby/object:Goldberg::Menu::Node \n      content_page_id: 1\n      controller_action_id: \n      id: 1\n      label: Home\n      name: home\n      parent: \n      parent_id: \n      site_controller_id: \n      url: /home\n    12: &id003 !ruby/object:Goldberg::Menu::Node \n      content_page_id: \n      controller_action_id: 12\n      id: 12\n      label: System Settings\n      name: setup/system_settings\n      parent: \n      parent_id: 9\n      site_controller_id: 9\n      url: /goldberg/system_settings/list\n    7: &id002 !ruby/object:Goldberg::Menu::Node \n      content_page_id: \n      controller_action_id: 8\n      id: 7\n      label: Content Pages\n      name: setup/pages\n      parent: \n      parent_id: 9\n      site_controller_id: 1\n      url: /goldberg/content_pages/list\n    2: &id007 !ruby/object:Goldberg::Menu::Node \n      children: \n      - 14\n      content_page_id: 6\n      controller_action_id: \n      id: 2\n      label: Contact Us\n      name: contact_us\n      parent: \n      parent_id: \n      site_controller_id: \n      url: /contact_us\n    13: &id001 !ruby/object:Goldberg::Menu::Node \n      content_page_id: \n      controller_action_id: 15\n      id: 13\n      label: Users\n      name: setup/users\n      parent: \n      parent_id: 9\n      site_controller_id: 10\n      url: /goldberg/users/list\n    8: &id012 !ruby/object:Goldberg::Menu::Node \n      content_page_id: \n      controller_action_id: 9\n      id: 8\n      label: Controllers / Actions\n      name: setup/controllers\n      parent: \n      parent_id: 9\n      site_controller_id: 8\n      url: /goldberg/site_controllers/list\n    3: &id005 !ruby/object:Goldberg::Menu::Node \n      children: \n      - 9\n      content_page_id: 9\n      controller_action_id: \n      id: 3\n      label: Administration\n      name: admin\n      parent: \n      parent_id: \n      site_controller_id: \n      url: /admin\n    14: &id010 !ruby/object:Goldberg::Menu::Node \n      content_page_id: 10\n      controller_action_id: \n      id: 14\n      label: Credits &amp; Licence\n      name: credits\n      parent: \n      parent_id: 2\n      site_controller_id: \n      url: /credits\n    9: &id008 !ruby/object:Goldberg::Menu::Node \n      children: \n      - 13\n      - 6\n      - 5\n      - 8\n      - 7\n      - 11\n      - 12\n      content_page_id: 8\n      controller_action_id: \n      id: 9\n      label: Setup\n      name: setup\n      parent: \n      parent_id: 3\n      site_controller_id: \n      url: /site_admin\n  by_name: \n    setup/users: *id001\n    setup/pages: *id002\n    setup/system_settings: *id003\n    setup/menus: *id004\n    admin: *id005\n    setup/roles: *id006\n    contact_us: *id007\n    setup: *id008\n    setup/permissions: *id009\n    credits: *id010\n    home: *id011\n    setup/controllers: *id012\n  crumbs: \n  - 1\n  root: &id013 !ruby/object:Goldberg::Menu::Node \n    children: \n    - 1\n    - 3\n    - 2\n    parent: \n  selected: \n    1: *id011\n  vector: \n  - *id013\n  - *id011\n','2006-06-23 21:03:48','2007-05-21 14:02:01','/menu/admin');"

    create_table 'goldberg_roles_permissions', force: true do |t|
      t.column 'role_id', :integer, default: 0, null: false
      t.column 'permission_id', :integer, default: 0, null: false
    end

    add_index 'goldberg_roles_permissions', ['role_id'], name: 'fk_roles_permission_role_id'
    add_index 'goldberg_roles_permissions', ['permission_id'], name: 'fk_roles_permission_permission_id'

    execute 'INSERT INTO `goldberg_roles_permissions` VALUES (4,3,1),(6,1,3),(7,3,2),(9,1,4),(10,2,5);'

    create_table 'goldberg_system_settings', force: true do |t|
      t.column 'site_name', :string, default: '', null: false
      t.column 'site_subtitle', :string
      t.column 'footer_message', :string, default: ''
      t.column 'public_role_id', :integer, default: 0, null: false
      t.column 'session_timeout', :integer, default: 0, null: false
      t.column 'default_markup_style_id', :integer, default: 0
      t.column 'site_default_page_id', :integer, default: 0, null: false
      t.column 'not_found_page_id', :integer, default: 0, null: false
      t.column 'permission_denied_page_id', :integer, default: 0, null: false
      t.column 'session_expired_page_id', :integer, default: 0, null: false
      t.column 'menu_depth', :integer, default: 0, null: false
      t.column 'start_path', :string
      t.column 'site_url_prefix', :string
      t.column 'self_reg_enabled', :boolean
      t.column 'self_reg_role_id', :integer
      t.column 'self_reg_confirmation_required', :boolean
      t.column 'self_reg_confirmation_error_page_id', :integer
      t.column 'self_reg_send_confirmation_email', :boolean
    end

    add_index 'goldberg_system_settings', ['public_role_id'], name: 'fk_system_settings_public_role_id'
    add_index 'goldberg_system_settings', ['site_default_page_id'], name: 'fk_system_settings_site_default_page_id'
    add_index 'goldberg_system_settings', ['not_found_page_id'], name: 'fk_system_settings_not_found_page_id'
    add_index 'goldberg_system_settings', ['permission_denied_page_id'], name: 'fk_system_settings_permission_denied_page_id'
    add_index 'goldberg_system_settings', ['session_expired_page_id'], name: 'fk_system_settings_session_expired_page_id'

    execute "INSERT INTO `goldberg_system_settings` VALUES (1,'Goldberg','A website development tool for Ruby on Rails','A <a href=\"http://goldberg.rubyforge.org\">Goldberg</a> site',1,7200,1,1,3,4,2,3,'','http://localhost:3000/',0,NULL,0,11,0);"
  end

  def self.down
    drop_table 'goldberg_permissions'
    drop_table 'goldberg_markup_styles'
    drop_table 'goldberg_content_pages'
    drop_table 'goldberg_site_controllers'
    drop_table 'goldberg_controller_actions'
    drop_table 'goldberg_menu_items'
    drop_table 'goldberg_roles'
    drop_table 'goldberg_roles_permissions'
    drop_table 'goldberg_system_settings'
  end
end
