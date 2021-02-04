set define off
set verify off
set feedback off
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
begin wwv_flow.g_import_in_progress := true; end;
/
 
--       AAAA       PPPPP   EEEEEE  XX      XX
--      AA  AA      PP  PP  EE       XX    XX
--     AA    AA     PP  PP  EE        XX  XX
--    AAAAAAAAAA    PPPPP   EEEE       XXXX
--   AA        AA   PP      EE        XX  XX
--  AA          AA  PP      EE       XX    XX
--  AA          AA  PP      EEEEEE  XX      XX
prompt  Set Credentials...
 
begin
 
  -- Assumes you are running the script connected to SQL*Plus as the Oracle user APEX_040200 or as the owner (parsing schema) of the application.
  wwv_flow_api.set_security_group_id(p_security_group_id=>nvl(wwv_flow_application_install.get_workspace_id,2528307577003643));
 
end;
/

begin wwv_flow.g_import_in_progress := true; end;
/
begin 

select value into wwv_flow_api.g_nls_numeric_chars from nls_session_parameters where parameter='NLS_NUMERIC_CHARACTERS';

end;

/
begin execute immediate 'alter session set nls_numeric_characters=''.,''';

end;

/
begin wwv_flow.g_browser_language := 'ru'; end;
/
prompt  Check Compatibility...
 
begin
 
-- This date identifies the minimum version required to import this file.
wwv_flow_api.set_version(p_version_yyyy_mm_dd=>'2012.01.01');
 
end;
/

prompt  Set Application ID...
 
begin
 
   -- SET APPLICATION ID
   wwv_flow.g_flow_id := nvl(wwv_flow_application_install.get_application_id,104);
   wwv_flow_api.g_id_offset := nvl(wwv_flow_application_install.get_offset,0);
null;
 
end;
/

prompt  ...ui types
--
 
begin
 
null;
 
end;
/

prompt  ...plugins
--
--application/shared_components/plugins/item_type/menuitem
 
begin
 
wwv_flow_api.create_plugin (
  p_id => 14105553394102204 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_type => 'ITEM TYPE'
 ,p_name => 'MENUITEM'
 ,p_display_name => 'Menu Item'
 ,p_supported_ui_types => 'DESKTOP'
 ,p_image_prefix => '#PLUGIN_PREFIX#'
 ,p_plsql_code => 
'/*'||unistr('\000a')||
'  Menu Item Plug-in'||unistr('\000a')||
''||unistr('\000a')||
'  See plug-in documentation for more information.'||unistr('\000a')||
'*/'||unistr('\000a')||
''||unistr('\000a')||
'procedure print_clob( p_text in clob )'||unistr('\000a')||
'as'||unistr('\000a')||
'  l_offset number := 1;'||unistr('\000a')||
'begin'||unistr('\000a')||
'  loop '||unistr('\000a')||
'    exit when l_offset > nvl(dbms_lob.getlength(p_text),0);'||unistr('\000a')||
'    htp.prn( dbms_lob.substr(p_text, 4000, l_offset) );'||unistr('\000a')||
'    l_offset := l_offset + 4000;'||unistr('\000a')||
'  end loop;'||unistr('\000a')||
'end;'||unistr('\000a')||
''||unistr('\000a')||
'function get_menu_html('||unistr('\000a')||
'  p_item                in apex_plugin.t_page_item,'||
''||unistr('\000a')||
'  p_plugin              in apex_plugin.t_plugin,'||unistr('\000a')||
'  p_value               in varchar2,'||unistr('\000a')||
'  p_display_value       out varchar2 )'||unistr('\000a')||
'return clob'||unistr('\000a')||
'as'||unistr('\000a')||
'  c_lvl            constant number := 1;'||unistr('\000a')||
'  c_is_leaf        constant number := 2;'||unistr('\000a')||
'  c_num            constant number := 3;'||unistr('\000a')||
'  c_display_value  constant number := 4;'||unistr('\000a')||
'  c_return_id      constant number := 5;'||unistr('\000a')||
'  c_html_format    constant number := 6;'||unistr('\000a')||
'  c_parent_id'||
'      constant number := 7;'||unistr('\000a')||
'  c_action_type    constant number := 8;'||unistr('\000a')||
'  c_action_value   constant number := 9;'||unistr('\000a')||
'  '||unistr('\000a')||
'  l_data_lvl             varchar2(32767);'||unistr('\000a')||
'  l_data_is_leaf         varchar2(32767);'||unistr('\000a')||
'  l_data_num             varchar2(32767);'||unistr('\000a')||
'  l_data_display_value   varchar2(32767);'||unistr('\000a')||
'  l_data_return_id       varchar2(32767);'||unistr('\000a')||
'  l_data_html_format     varchar2(32767);'||unistr('\000a')||
'  l_data_parent_id       varchar2(3'||
'2767);'||unistr('\000a')||
'  l_data_action_type     varchar2(32767);'||unistr('\000a')||
'  l_data_action_value    varchar2(32767);'||unistr('\000a')||
'  '||unistr('\000a')||
'  l_html                 clob;'||unistr('\000a')||
'  l_pos                  number;'||unistr('\000a')||
'  l_curr_lvl             number;'||unistr('\000a')||
'  '||unistr('\000a')||
'  l_sql                  varchar2(32767);'||unistr('\000a')||
'  l_item_id              varchar2(30) := p_item.name;'||unistr('\000a')||
'  '||unistr('\000a')||
'  l_option_alignment     varchar2(30) := nvl(p_item.attribute_03,''LEFT'');'||unistr('\000a')||
'  l_option_alignment_class varcha'||
'r2(30);'||unistr('\000a')||
'  '||unistr('\000a')||
'  l_column_value_list    wwv_flow_plugin_util.t_column_value_list;'||unistr('\000a')||
'  '||unistr('\000a')||
'  INVALID_IDENTIFIER exception;'||unistr('\000a')||
'  pragma exception_init(INVALID_IDENTIFIER, -904);'||unistr('\000a')||
'begin'||unistr('\000a')||
'  -- calc option alignment'||unistr('\000a')||
'  case l_option_alignment'||unistr('\000a')||
'    when ''LEFT''   then l_option_alignment_class := ''mi-left'';'||unistr('\000a')||
'    when ''CENTER'' then l_option_alignment_class := ''mi-center'';'||unistr('\000a')||
'    when ''RIGHT''  then l_option_alignment_class := '||
'''mi-right'';'||unistr('\000a')||
'  end case;  '||unistr('\000a')||
''||unistr('\000a')||
'  -- get all values'||unistr('\000a')||
'  begin'||unistr('\000a')||
'    -- columns: level, num, display_value, return_id, html_format, parent_id, action_type, action_value'||unistr('\000a')||
'    l_sql := ''select level lvl,connect_by_isleaf is_leaf,T2.* from ('''||unistr('\000a')||
'          || ''  select rownum num,T.*'''||unistr('\000a')||
'          || ''  from ('' || p_item.lov_definition || '') T'''||unistr('\000a')||
'          || '') T2 '''||unistr('\000a')||
'          || ''start with T2.parent_id is null '''||unistr('\000a')||
'     '||
'     || ''connect by T2.parent_id = prior T2.return_id '''||unistr('\000a')||
'          || ''order siblings by T2.num'';'||unistr('\000a')||
''||unistr('\000a')||
'    l_column_value_list := apex_plugin_util.get_data ( p_sql_statement      => l_sql -- p_item.lov_definition'||unistr('\000a')||
'                                                     , p_min_columns        => 5'||unistr('\000a')||
'                                                     , p_max_columns        => 9'||unistr('\000a')||
'                              '||
'                       , p_component_name     => p_item.name );'||unistr('\000a')||
'  exception when INVALID_IDENTIFIER then'||unistr('\000a')||
''||unistr('\000a')||
'    -- if parent_id not found then try to interpret query as non-hierarchical'||unistr('\000a')||
'    l_sql := ''select 1 lvl, 1 is_leaf, rownum num, T.* from ('' || p_item.lov_definition || '') T'';'||unistr('\000a')||
''||unistr('\000a')||
'    l_column_value_list := apex_plugin_util.get_data ( p_sql_statement      => l_sql'||unistr('\000a')||
'                                '||
'                     , p_min_columns        => 5'||unistr('\000a')||
'                                                     , p_max_columns        => 9'||unistr('\000a')||
'                                                     , p_component_name     => p_item.name );'||unistr('\000a')||
'  end;'||unistr('\000a')||
''||unistr('\000a')||
'  l_curr_lvl := 0;'||unistr('\000a')||
'  for i in 1 .. l_column_value_list(c_display_value).count loop'||unistr('\000a')||
''||unistr('\000a')||
'    l_data_lvl           := l_column_value_list(c_lvl)(i);'||unistr('\000a')||
'    l_data_is_leaf       '||
':= l_column_value_list(c_is_leaf)(i);'||unistr('\000a')||
'    l_data_num           := l_column_value_list(c_num)(i); '||unistr('\000a')||
'    l_data_display_value := l_column_value_list(c_display_value)(i);'||unistr('\000a')||
'    l_data_return_id     := l_column_value_list(c_return_id)(i);'||unistr('\000a')||
'    '||unistr('\000a')||
'    if l_column_value_list.exists(c_html_format) then'||unistr('\000a')||
''||unistr('\000a')||
'      l_data_html_format := nvl( l_column_value_list(c_html_format)(i), ''#TEXT#'');'||unistr('\000a')||
'    else'||unistr('\000a')||
'      l_data_htm'||
'l_format := ''#TEXT#'';'||unistr('\000a')||
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
'    if l_column_value_list.exists(c_parent_id) then'||unistr('\000a')||
''||unistr('\000a')||
'      l_data_parent_id := l_column_value_list(c_parent_id)(i);'||unistr('\000a')||
'    else'||unistr('\000a')||
'      l_data_parent_id := null;'||unistr('\000a')||
'    end if;'||unistr('\000a')||
'    '||unistr('\000a')||
'    if l_column_value_list.exists(c_action_type) then'||unistr('\000a')||
''||unistr('\000a')||
'      l_data_action_type := nvl( l_column_value_list(c_action_type)(i), ''NOACTION'' );'||unistr('\000a')||
'    else'||unistr('\000a')||
'      l_data_action_type := ''NOACTION'';'||unistr('\000a')||
' '||
'   end if;'||unistr('\000a')||
'    '||unistr('\000a')||
'    if l_column_value_list.exists(c_action_value) then'||unistr('\000a')||
''||unistr('\000a')||
'      l_data_action_value := l_column_value_list(c_action_value)(i);'||unistr('\000a')||
'    else '||unistr('\000a')||
'      l_data_action_value := null;'||unistr('\000a')||
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
'    if l_curr_lvl < l_data_lvl then'||unistr('\000a')||
''||unistr('\000a')||
'      if l_data_lvl = 1 then'||unistr('\000a')||
''||unistr('\000a')||
'        l_html := concat(l_html, ''<ul style="display:none" id="'' || p_item.name || ''_menu" class="mi-menu">'');'||unistr('\000a')||
'      else'||unistr('\000a')||
'        l_ht'||
'ml := concat(l_html, ''<ul style="display:none" class="mi-submenu">'');'||unistr('\000a')||
'      end if;'||unistr('\000a')||
''||unistr('\000a')||
'      l_curr_lvl := l_data_lvl;'||unistr('\000a')||
''||unistr('\000a')||
'    elsif l_curr_lvl > l_data_lvl then'||unistr('\000a')||
''||unistr('\000a')||
'      for j in 1..l_curr_lvl-l_data_lvl loop'||unistr('\000a')||
''||unistr('\000a')||
'        l_html := concat(l_html, ''</ul></li>'');'||unistr('\000a')||
'      end loop;'||unistr('\000a')||
''||unistr('\000a')||
'      l_curr_lvl := l_data_lvl;'||unistr('\000a')||
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
'    case '||unistr('\000a')||
'      when l_data_action_type = ''NOACTION'' then l_data_action_value := null;'||
' '||unistr('\000a')||
'      when l_data_action_type = ''REDIRECT'' then l_data_action_value := nvl( l_data_action_value'||unistr('\000a')||
'                                                                          , ''f?p='' || v(''APP_ID'') || '':'' || v(''APP_PAGE_ID'') || '':'' || v(''SESSION'') || '':'' '||unistr('\000a')||
'                                                                            || ''MENU_'' || l_data_return_id || '':'' || v(''DEBUG'') || ''::'' || l_item_'||
'id || '':'' || l_data_return_id ); '||unistr('\000a')||
'      when l_data_action_type = ''SUBMIT''   then l_data_action_value := nvl( l_data_action_value, ''MENU_'' || l_data_return_id ); '||unistr('\000a')||
'      else raise_application_error(-20000, ''Incorrect value for ACTION_VALUE column in LOV query. Expected one of the following: null, ''''NOACTION'''', ''''REDIRECT'''', ''''REDIRECT_URL'''', ''''SUBMIT''''; got '''''' || l_data_action_type || ''''''.'' );'||unistr('\000a')||
'  '||
'  end case;'||unistr('\000a')||
''||unistr('\000a')||
'    if ( l_data_return_id = p_value ) then'||unistr('\000a')||
''||unistr('\000a')||
'      p_display_value := l_data_display_value;'||unistr('\000a')||
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
'    if  l_data_is_leaf = 0 then'||unistr('\000a')||
''||unistr('\000a')||
'      l_pos := instr(l_html,''<ul '',-1);'||unistr('\000a')||
'      l_pos := instr(l_html,''class="'',l_pos);'||unistr('\000a')||
'      l_pos := instr(l_html,''"'',l_pos+7);'||unistr('\000a')||
''||unistr('\000a')||
'      l_html := substr(l_html,1,l_pos-1) || '' mi-has-child'' || substr(l_html,l_pos);'||unistr('\000a')||
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
'    l_html := concat(l_'||
'html, ''<li  class="mi-menu-option '' || l_option_alignment_class || case when l_data_is_leaf=0 then '' mi-option-has-child'' end || ''" returnid="'' || l_data_return_id || ''" actiontype="'' || l_data_action_type || ''" actionvalue="'' || l_data_action_value || ''" >'' '||unistr('\000a')||
'                          || case when l_data_is_leaf=0 then ''<span class="mi-option-icon ui-icon ui-icon-black mi-ui-icon-carat-1-e"></span'||
'>'' end'||unistr('\000a')||
'                          || ''<span class="mi-option-text" c-value="'' || apex_plugin_util.escape ( l_data_display_value, true ) || ''">'' || replace( l_data_html_format, ''#TEXT#'', l_data_display_value ) || ''</span>'''||unistr('\000a')||
'                          || case when l_data_is_leaf=1 then ''</li>'' end );'||unistr('\000a')||
'  end loop;'||unistr('\000a')||
''||unistr('\000a')||
'  for j in 2..l_curr_lvl loop'||unistr('\000a')||
''||unistr('\000a')||
'    l_html := concat(l_html, ''</ul></li>'');'||unistr('\000a')||
'  end loop;'||unistr('\000a')||
'  l'||
'_html := concat(l_html, ''</ul>'');'||unistr('\000a')||
'  '||unistr('\000a')||
'  return l_html;'||unistr('\000a')||
'end;'||unistr('\000a')||
''||unistr('\000a')||
'function render_menu_item ('||unistr('\000a')||
'  p_item                in apex_plugin.t_page_item,'||unistr('\000a')||
'  p_plugin              in apex_plugin.t_plugin,'||unistr('\000a')||
'  p_value               in varchar2,'||unistr('\000a')||
'  p_is_readonly         in boolean,'||unistr('\000a')||
'  p_is_printer_friendly in boolean )'||unistr('\000a')||
'return apex_plugin.t_page_item_render_result'||unistr('\000a')||
'as'||unistr('\000a')||
'  l_result               wwv_flow_plugin.t_page_item_'||
'render_result;'||unistr('\000a')||
''||unistr('\000a')||
'  l_value                varchar2(32767) := p_value;'||unistr('\000a')||
'  l_text                 varchar2(32767);'||unistr('\000a')||
'  l_name                 varchar2(4000) := apex_plugin.get_input_name_for_page_item(false);'||unistr('\000a')||
''||unistr('\000a')||
'  l_display_element_name varchar2(30) := p_item.name || ''_display'';'||unistr('\000a')||
'  l_display_block_id     varchar2(30) := p_item.name || ''_block'';'||unistr('\000a')||
'  l_display_value        varchar2(32767);'||unistr('\000a')||
'  l_menu_id         '||
'     varchar2(30) := p_item.name || ''_menu'';'||unistr('\000a')||
'  l_item_id              varchar2(30) := p_item.name;'||unistr('\000a')||
''||unistr('\000a')||
'  l_select_menu_option   varchar2(30) := p_item.attribute_01;'||unistr('\000a')||
''||unistr('\000a')||
'  l_active_theme         varchar2(30) := p_item.attribute_04;'||unistr('\000a')||
'  l_active_theme_class   varchar2(255);'||unistr('\000a')||
''||unistr('\000a')||
'  l_alt                  varchar2(32767) := p_item.attribute_05;'||unistr('\000a')||
'  l_icon                 varchar2(32767);'||unistr('\000a')||
'  l_null_display_value   va'||
'rchar2(32767) := p_item.attribute_06;'||unistr('\000a')||
''||unistr('\000a')||
'  l_display_format       varchar2(32767) := p_item.attribute_07;'||unistr('\000a')||
''||unistr('\000a')||
'  l_parent_items         varchar2(255)   := p_item.lov_cascade_parent_items;'||unistr('\000a')||
'  l_items_to_submit      varchar2(255)   := p_item.ajax_items_to_submit;'||unistr('\000a')||
'  l_optimize_refresh     boolean         := p_item.ajax_optimize_refresh;'||unistr('\000a')||
''||unistr('\000a')||
'  l_html                 clob;'||unistr('\000a')||
'begin'||unistr('\000a')||
'  -- print debug information'||unistr('\000a')||
'  if'||
' apex_application.g_debug then'||unistr('\000a')||
'      apex_plugin_util.debug_page_item ('||unistr('\000a')||
'          p_plugin              => p_plugin,'||unistr('\000a')||
'          p_page_item           => p_item,'||unistr('\000a')||
'          p_value               => p_value,'||unistr('\000a')||
'          p_is_readonly         => p_is_readonly,'||unistr('\000a')||
'          p_is_printer_friendly => p_is_printer_friendly );'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'    apex_css.add_file ( p_name => ''mi'''||unistr('\000a')||
'                      , p_directory '||
'=> p_plugin.file_prefix );'||unistr('\000a')||
''||unistr('\000a')||
'    apex_javascript.add_library ( p_name => ''mi'''||unistr('\000a')||
'                                , p_directory => p_plugin.file_prefix );'||unistr('\000a')||
''||unistr('\000a')||
'  case l_active_theme'||unistr('\000a')||
'    when ''BLUE''      then l_active_theme_class := ''ui-icon-blue'';'||unistr('\000a')||
'    when ''RED''       then l_active_theme_class := ''ui-icon-red'';'||unistr('\000a')||
'    when ''BLACK''     then l_active_theme_class := ''ui-icon-black'';'||unistr('\000a')||
'    when ''GREY''      then l_a'||
'ctive_theme_class := ''ui-icon-grey'';'||unistr('\000a')||
'    when ''LIGHTGREY'' then l_active_theme_class := ''ui-icon-light-grey'';'||unistr('\000a')||
'  end case;'||unistr('\000a')||
''||unistr('\000a')||
'  apex_javascript.add_inline_code ('||unistr('\000a')||
'    p_code => '''||unistr('\000a')||
'     mi_init("'' || l_display_block_id '||unistr('\000a')||
'                || ''", "'' || l_menu_id '||unistr('\000a')||
'                || ''", "'' || l_item_id '||unistr('\000a')||
'                || ''", "'' || l_select_menu_option '||unistr('\000a')||
'                || ''", "'' || l_active_theme_class'||unistr('\000a')||
'      '||
'          || ''", "'' || replace( replace( apex_plugin_util.escape( l_display_format, true ), chr(10), '''' ), chr(13), '''' )'||unistr('\000a')||
'                || ''", "'' || apex_plugin.get_ajax_identifier'||unistr('\000a')||
'                || ''", "'' || apex_plugin_util.page_item_names_to_jquery( l_parent_items )'||unistr('\000a')||
'                || ''", "'' || apex_plugin_util.page_item_names_to_jquery( l_items_to_submit )'||unistr('\000a')||
'                || ''");'||unistr('\000a')||
'  '');'||unistr('\000a')||
''||unistr('\000a')||
'  l_'||
'html := get_menu_html( p_item, p_plugin, p_value, l_text );'||unistr('\000a')||
''||unistr('\000a')||
'  if l_text is null then'||unistr('\000a')||
''||unistr('\000a')||
'    l_text := l_null_display_value;'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  l_display_format := substr(l_display_format,1,instr(l_display_format,''#DISPLAY_VALUE#'')-1)'||unistr('\000a')||
'                   || apex_plugin_util.escape ( ''#DISPLAY_VALUE#'', true )'||unistr('\000a')||
'                   || substr(l_display_format,instr(l_display_format,''#DISPLAY_VALUE#'') + length(''#'||
'DISPLAY_VALUE#'') );'||unistr('\000a')||
''||unistr('\000a')||
'  l_display_format := replace(l_display_format,''#DISPLAY_VALUE#'',l_text);'||unistr('\000a')||
''||unistr('\000a')||
'  -- two modes are supported: readonly and normal both contain hidden and readonly elements'||unistr('\000a')||
'  if p_is_readonly or p_is_printer_friendly then'||unistr('\000a')||
''||unistr('\000a')||
'    l_display_value := '||unistr('\000a')||
'       ''<span class="mi-display" id="'' || l_display_block_id || ''" title="'' || l_alt || ''">'''||unistr('\000a')||
'    ||   ''<span class="mi-label">'' || l_displ'||
'ay_format || ''</span>'''||unistr('\000a')||
'    || ''</span>'';  '||unistr('\000a')||
'    '||unistr('\000a')||
'    htp.prn(''<input type="hidden" name="''||l_name||''" id="''||p_item.name||''" value="'' || p_value || ''" />'');'||unistr('\000a')||
''||unistr('\000a')||
'    apex_plugin_util.print_display_only ('||unistr('\000a')||
'      p_item_name        => l_display_element_name,'||unistr('\000a')||
'      p_display_value    => l_display_value,'||unistr('\000a')||
'      p_show_line_breaks => false,'||unistr('\000a')||
'      p_escape           => false,'||unistr('\000a')||
'      p_attributes       => p_ite'||
'm.element_attributes );'||unistr('\000a')||
'  else'||unistr('\000a')||
'    l_display_value := '||unistr('\000a')||
'       ''<span class="mi-display" id="'' || l_display_block_id || ''" title="'' || l_alt || ''">'''||unistr('\000a')||
'    ||   ''<span class="mi-label">'' || l_display_format || ''</span>'''||unistr('\000a')||
'    ||   ''<span class="mi-icon ui-icon ui-icon-black mi-ui-icon-triangle-1-s"></span>'''||unistr('\000a')||
'    || ''</span>'';'||unistr('\000a')||
'    '||unistr('\000a')||
'    htp.prn(''<input type="hidden" name="''||l_name||''" id="''||p_item.name||'||
'''" value="'' || p_value || ''" />'');'||unistr('\000a')||
''||unistr('\000a')||
'    apex_plugin_util.print_display_only ('||unistr('\000a')||
'      p_item_name        => l_display_element_name,'||unistr('\000a')||
'      p_display_value    => l_display_value,'||unistr('\000a')||
'      p_show_line_breaks => false,'||unistr('\000a')||
'      p_escape           => false,'||unistr('\000a')||
'      p_attributes       => p_item.element_attributes );'||unistr('\000a')||
''||unistr('\000a')||
'    print_clob(l_html);'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  return l_result;'||unistr('\000a')||
'end;'||unistr('\000a')||
''||unistr('\000a')||
'function ajax_menu_item ('||unistr('\000a')||
'    p_item '||
'  in apex_plugin.t_page_item,'||unistr('\000a')||
'    p_plugin in apex_plugin.t_plugin )'||unistr('\000a')||
'return apex_plugin.t_page_item_ajax_result'||unistr('\000a')||
'as'||unistr('\000a')||
'  l_result apex_plugin.t_page_item_ajax_result;'||unistr('\000a')||
''||unistr('\000a')||
'  l_text   varchar2(32767);'||unistr('\000a')||
'  l_html   clob;'||unistr('\000a')||
'begin'||unistr('\000a')||
'  owa_util.mime_header(''text/plain'',true);'||unistr('\000a')||
''||unistr('\000a')||
'  l_html := get_menu_html( p_item, p_plugin, null, l_text );'||unistr('\000a')||
'  print_clob(l_html);'||unistr('\000a')||
''||unistr('\000a')||
'  return l_result;'||unistr('\000a')||
'end;'
 ,p_render_function => 'render_menu_item'
 ,p_ajax_function => 'ajax_menu_item'
 ,p_standard_attributes => 'VISIBLE:SESSION_STATE:READONLY:QUICKPICK:SOURCE:ELEMENT:LOV:LOV_REQUIRED:CASCADING_LOV'
 ,p_sql_min_column_count => 2
 ,p_sql_max_column_count => 6
 ,p_sql_examples => '<pre>'||unistr('\000a')||
'select E.ENAME as display_value'||unistr('\000a')||
'     , E.EMPNO as return_id'||unistr('\000a')||
'     , null html_format'||unistr('\000a')||
'     , decode(E.MGR,7839,null,E.MGR) as parent_id'||unistr('\000a')||
'     , ''SUBMIT'' as action_type'||unistr('\000a')||
'from EMP E'||unistr('\000a')||
'order by E.ENAME'||unistr('\000a')||
'</pre>'
 ,p_substitute_attributes => true
 ,p_subscribe_plugin_settings => true
 ,p_help_text => '<p>'||unistr('\000a')||
'	<strong>Menu Item Plug-in</strong></p>'||unistr('\000a')||
'<p>'||unistr('\000a')||
'	Menu Item is a display only element with attached menu with different customizable features. It can be used as an alternative to standard select list or as a standalone menu element.</p>'||unistr('\000a')||
''
 ,p_version_identifier => '1.0'
 ,p_about_url => 'https://github.com/ivyachmenev/Menu-Item'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 14110859906311888 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 14105553394102204 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 1
 ,p_display_sequence => 10
 ,p_prompt => 'Menu Options are Selectable'
 ,p_attribute_type => 'SELECT LIST'
 ,p_is_required => true
 ,p_default_value => 'YES'
 ,p_is_translatable => false
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 14111458180312707 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 14110859906311888 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'Yes'
 ,p_return_value => 'YES'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 14111856024313753 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 14110859906311888 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => 'No'
 ,p_return_value => 'NO'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 14148742076502180 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 14105553394102204 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 4
 ,p_display_sequence => 40
 ,p_prompt => 'Theme for Active Element Icons'
 ,p_attribute_type => 'SELECT LIST'
 ,p_is_required => true
 ,p_default_value => 'BLUE'
 ,p_is_translatable => false
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 14149337547504239 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 14148742076502180 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'Blue'
 ,p_return_value => 'BLUE'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 14149736038504971 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 14148742076502180 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => 'Red'
 ,p_return_value => 'RED'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 14150133881505915 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 14148742076502180 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 30
 ,p_display_value => 'Black'
 ,p_return_value => 'BLACK'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 14150532156506728 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 14148742076502180 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 40
 ,p_display_value => 'Grey'
 ,p_return_value => 'GREY'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 14150944220516371 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 14148742076502180 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 50
 ,p_display_value => 'Light Grey'
 ,p_return_value => 'LIGHTGREY'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 14156354830724157 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 14105553394102204 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 5
 ,p_display_sequence => 50
 ,p_prompt => 'Alt'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => false
 ,p_default_value => 'Click to change the value.'
 ,p_is_translatable => false
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 14160734740429200 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 14105553394102204 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 6
 ,p_display_sequence => 60
 ,p_prompt => 'Null Display Value'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => false
 ,p_default_value => 'null'
 ,p_is_translatable => true
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 14687447233933118 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 14105553394102204 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 7
 ,p_display_sequence => 70
 ,p_prompt => 'Display Format'
 ,p_attribute_type => 'TEXTAREA'
 ,p_is_required => true
 ,p_default_value => '#DISPLAY_VALUE#'
 ,p_is_translatable => false
  );
null;
 
end;
/

 
begin
 
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '202020202E6D692D6C6162656C207B20646973706C61793A696E6C696E653B207D0D0A202020202E6D692D686F766572207B20746578742D6465636F726174696F6E3A756E6465726C696E653B20637572736F723A20706F696E746572207D0D0A0D0A20';
wwv_flow_api.g_varchar2_table(2) := '2020202E6D692D6D656E75207B200D0A200D0A202020202020646973706C61793A206E6F6E653B200D0A202020202020706F736974696F6E3A206162736F6C7574653B200D0A202020202020626F726465723A2031707820736F6C696420234141413B0D';
wwv_flow_api.g_varchar2_table(3) := '0A202020202020746578742D616C69676E3A206C6566743B0D0A0D0A2020202020207A2D696E6465783A203130303B0D0A2020202020206261636B67726F756E642D636F6C6F723A2077686974653B0D0A202020207D0D0A202020202E6D692D7375626D';
wwv_flow_api.g_varchar2_table(4) := '656E75207B200D0A200D0A202020202020646973706C61793A206E6F6E653B200D0A202020202020706F736974696F6E3A206162736F6C7574653B200D0A202020202020626F726465723A2031707820736F6C696420234141413B0D0A20202020202074';
wwv_flow_api.g_varchar2_table(5) := '6578742D616C69676E3A206C6566743B0D0A0D0A2020202020207A2D696E6465783A203130303B0D0A2020202020206261636B67726F756E642D636F6C6F723A2077686974653B0D0A202020207D0D0A202020202E75692D69636F6E2D626C7565207B20';
wwv_flow_api.g_varchar2_table(6) := '2020202020206261636B67726F756E642D696D6167653A2075726C282223504C5547494E5F5052454649582375692D69636F6E735F3265383366665F323536783234302E706E6722293B207D0D0A202020202E75692D69636F6E2D726564207B20202020';
wwv_flow_api.g_varchar2_table(7) := '202020206261636B67726F756E642D696D6167653A2075726C282223504C5547494E5F5052454649582375692D69636F6E735F6364306130615F323536783234302E706E6722293B207D0D0A202020202E75692D69636F6E2D626C61636B207B20202020';
wwv_flow_api.g_varchar2_table(8) := '20206261636B67726F756E642D696D6167653A2075726C282223504C5547494E5F5052454649582375692D69636F6E735F3232323232325F323536783234302E706E6722293B207D0D0A202020202E75692D69636F6E2D67726579207B20202020202020';
wwv_flow_api.g_varchar2_table(9) := '6261636B67726F756E642D696D6167653A2075726C282223504C5547494E5F5052454649582375692D69636F6E735F3435343534355F323536783234302E706E6722293B207D0D0A202020202E75692D69636F6E2D6C696768742D67726579207B206261';
wwv_flow_api.g_varchar2_table(10) := '636B67726F756E642D696D6167653A2075726C282223504C5547494E5F5052454649582375692D69636F6E735F3838383838385F323536783234302E706E6722293B207D0D0A0D0A202020202E6D692D69636F6E207B200D0A0D0A202020202020206469';
wwv_flow_api.g_varchar2_table(11) := '73706C61793A20696E6C696E652D626C6F636B202120696D706F7274616E743B0D0A20202020202020766572746963616C2D616C69676E3A20746F703B0D0A20202020202020706F736974696F6E3A2072656C61746976653B0D0A202020202020206C65';
wwv_flow_api.g_varchar2_table(12) := '66743A202D3270783B0D0A20202020207D0D0A0D0A202020202E6D692D6D656E752D6F7074696F6E207B0D0A0D0A2020202020206C6973742D7374796C653A206F757473696465206E6F6E65206E6F6E653B200D0A20202020202070616464696E673A20';
wwv_flow_api.g_varchar2_table(13) := '3370782035707820337078203470783B0D0A202020207D0D0A202020202E6D692D6861732D6368696C64206C692E6D692D6D656E752D6F7074696F6E207B2070616464696E672D72696768743A2031367078207D0D0A202020202E6D692D6F7074696F6E';
wwv_flow_api.g_varchar2_table(14) := '2D686F766572207B200D0A0D0A202020202020746578742D6465636F726174696F6E3A206E6F6E653B200D0A202020202020637572736F723A20706F696E7465723B200D0A2020202020206261636B67726F756E642D636F6C6F723A2023444144414441';
wwv_flow_api.g_varchar2_table(15) := '3B200D0A0D0A202020202020626F726465723A2031707820736F6C696420234141413B0D0A2020202020206D617267696E3A202D3170783B0D0A202020207D0D0A0D0A202020202E6D692D6C656674207B20746578742D616C69676E3A206C656674207D';
wwv_flow_api.g_varchar2_table(16) := '0D0A202020202E6D692D63656E746572207B20746578742D616C69676E3A2063656E746572207D0D0A202020202E6D692D7269676874207B20746578742D616C69676E3A207269676874207D0D0A0D0A202020202E6D692D6F7074696F6E2D7465787420';
wwv_flow_api.g_varchar2_table(17) := '7B2077686974652D73706163653A206E6F77726170207D0D0A202020202E6D692D6F7074696F6E2D69636F6E207B200D0A0D0A202020202020706F736974696F6E3A206162736F6C7574653B200D0A20202020202072696768743A203070783B200D0A20';
wwv_flow_api.g_varchar2_table(18) := '202020202077696474683A20313670783B200D0A2020202020206865696768743A20313670783B200D0A202020202020646973706C61793A20626C6F636B0D0A202020207D0D0A090D0A092E6D692D6C6F6164696E672D696E64696361746F72207B0D0A';
wwv_flow_api.g_varchar2_table(19) := '09096261636B67726F756E642D696D6167653A75726C2823494D4147455F50524546495823617065782F6275696C6465722F6C6F6164696E6731367831362E676966293B0D0A090970616464696E673A3170782038707820317078203870783B0D0A097D';
wwv_flow_api.g_varchar2_table(20) := '0D0A090D0A092E6D692D75692D69636F6E2D63617261742D312D65207B0D0A09096261636B67726F756E642D706F736974696F6E3A202D3332707820303B0D0A097D0D0A092E6D692D75692D69636F6E2D747269616E676C652D312D73207B0D0A090962';
wwv_flow_api.g_varchar2_table(21) := '61636B67726F756E642D706F736974696F6E3A202D36347078202D313670783B0D0A097D';
null;
 
end;
/

 
begin
 
wwv_flow_api.create_plugin_file (
  p_id => 3140309215136238 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 14105553394102204 + wwv_flow_api.g_id_offset
 ,p_file_name => 'mi.css'
 ,p_mime_type => 'text/css'
 ,p_file_content => wwv_flow_api.g_varchar2_table
  );
null;
 
end;
/

 
begin
 
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '89504E470D0A1A0A0000000D4948445200000100000000F00803000000D8494AF9000000ED504C54452E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83';
wwv_flow_api.g_varchar2_table(2) := 'FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF';
wwv_flow_api.g_varchar2_table(3) := '2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2E83FF2581CC980000004E74524E5300181032040850BF8399';
wwv_flow_api.g_varchar2_table(4) := '2E2254704066601A12CD0C203C1642484A1E5A2630522C85348781C36AC9CFC738441CBDB97CABB5A58DA9ADB328FD9F24EF0A06028FA36295A1AF6CDF9D463E6E7E916868D248FD00000F8549444154789CED5D8D62DBB61106C948AAE584922D7B69EC';
wwv_flow_api.g_varchar2_table(5) := '5A4B3A67F3926C6BD76EAD9A2DA9D37449D7F5DEFF71068004713F202045B224DBF8644B3E0224EE3E1EC13B009495CAC8C8D8031450EC5A859DA200D87306D656AF8068211498015379BB84300F040345B7307D48B9292DF016E0E616740B6B80ED6FFF';
wwv_flow_api.g_varchar2_table(6) := 'DCAA4B700F9404145C1F52CECFA02080EF2E1B1095458B3708A1BF0A9A1029970C2A563B7EF45065DEE20D4278B0122AF2132C3D247A86A5074414D8BE078410ED03A21E1CAC20FA00C54AB1BDDBEF03D2B8D9BB00BF84B67F17D839EE7B209491919191';
wwv_flow_api.g_varchar2_table(7) := '9191B1C7B8F14870C771105740C4F22232270601F0049FDB131F0F100342FAE85BA524A080204054E0D569BA48D52FE4E162D9A539FA369321A17F58E34871604445A4C72A52CE009680AD0D07480F56219F25D9DA12E30185A23BD0F2D4F0C1EED3E122';
wwv_flow_api.g_varchar2_table(8) := 'A2F1FAE301F20AD9691F90C65DBF0B6464646464646464EC0EEB05FEC9D03479FCB5138F350F20F48F1AF40989526207B91C402894389ADC14DB436487F6C5AAD0DDA1AF2CDC4054814069BCFDD01162048972713061816C0E5821F414B60794FAB01DA0';
wwv_flow_api.g_varchar2_table(9) := 'AF7089F665BA2C09EBDF3D3462145720BC7BA40A35B0ADCDC6AC68757EC0287FC11A51178A5E4081E3F33314DA3DEEA2E916228562FFE4351E5843141B404A1F919D8EB84387AAA4FA8054E9AEEF0237BC7FFA3699919191919191715FB1FEB2D435C30C';
wwv_flow_api.g_varchar2_table(10) := 'A9402C7209C5A1C9A9AA44F3AB29B05403F17C9E4F9C851440E50A4F4E2D11D599CAFDC90904A7F7A592E290FDED07F25B6E40ECD85201BCA19958F414496D038BDD8B280189B5E1A14620CA40943FB1F03D30DE12A00870754C91983B671E24D2E14036';
wwv_flow_api.g_varchar2_table(11) := 'CEB784F4170A844B0307601ACAFD033ED0BFBB20406820D5A3E5FC124B131056806E111512C52261A622AB8F0BF925106C821B402E017689242F81F0555EF4D6100C471707C83A010723609D60A09220807582AC54744BA9111CDE7EE01CC58BC35AA0DD';
wwv_flow_api.g_varchar2_table(12) := 'F9351C54BCBF8925D66BECF578C0AE9F8FC9C8C8C8C8C8D86BDCEC5D5C062AEC51D9C01E9B0D2CD2878B05D2EB4286AA34340BDA4F584BCD7C058A7982CE6783B9C1102B5F134DA4281603FB6CD0BE459E0E4F84FA810A200C5624FB54314258F5F50192';
wwv_flow_api.g_varchar2_table(13) := '0162A22D8A7C3F4020D466F3D542DF5872E0F6252740D2B941025CBA49B4E1B94A2C7D8680424263E1F35C06560AF1CA728DC1A7A3086828D25D7449C8EC5EAA19F311A17DDCC7C5196FCED7A66F0CBE53338309223BA3CFF707CA9910BAECD1C1627DDC';
wwv_flow_api.g_varchar2_table(14) := '129D22DFB009100F97D9297B622491BDA61601A5C61FE2E347771077DDBE8C8C8C8C8CBB8DF296DFC80261879CDE6222DEF029F6EFD35440709A85465F657236104A76D0A8A802E1F60EC1226DE8DEADAC4D2DC19F6437F3EA3694D07880AFAF84CBB036';
wwv_flow_api.g_varchar2_table(15) := '02D3A53B04C8EC852FAFD7F693EC8C10603E4B7204505CC4F616B05F04B8D9EB5E758C312593DB4F15FA54824DB2ADE82EB17DB90496F000511F33E608EAF180B62E1B4ED8B307E4E37D00AB111CA129BD97F03E80F705FBE4FE2DE2778160978FEA9761';
wwv_flow_api.g_varchar2_table(16) := '83F81097C316BF2B737924E380E401CA741D87F89729DC4EAC627F46464646C6FD4265E2846AF9FA0F061A0F6E4E1F8AA1566E348CD5F82C11B9C141132AF59958F1E22ACEC703350618AB07A43ED9E3508B87AA47E685EA610BB68333091ED5F510057B';
wwv_flow_api.g_varchar2_table(17) := 'F66F42880D8B263C14F4944C5B0BA7C4DE4E632E8B99ADC3B6DC693D18C36000E3015140896482AFB50D0ACD8649A8C52E49ABEBBA6CC0081911021003605C74E05B3C2004E8431F6974A134380FC0F934C92D060372C0010C8E8F2BC004CC66B3D8EC91';
wwv_flow_api.g_varchar2_table(18) := 'B1068242908043422018D3D1064D4881096914A4849F18F479000C017D9886DB3EC0C9CD7278A4F189DDFDC413707C7AF83B42C0E3C78F153BE162B175AF8B72028CFD9F6302A84B81B69FFA183474A0061F1BF47AC091311D86477E1CA0B2FEDF11608E';
wwv_flow_api.g_varchar2_table(19) := '8F86D89AC3F903EA4BE0C9137C09CC943E05FABDDBA1B2AF4F24C0D8FFF0ECF37E020AB6416F298AA302A530707A7A0ABD7D001C6906B4FD9800FBD311603B4144C0B9D9FBFCDC6D386E3AC163660EDA4112407337BAC112F0051E9F984C1FEAF7BA8F00';
wwv_flow_api.g_varchar2_table(20) := 'DE201C5AA0062F2E2EC0BBA8F080EA6838D46FFE12B0723F01170DDA0DC5184EC7E3398CF13342E812D21B7E6F5FD8DE012760C00800E201136F7F8480EE704F2D98CB0D3A02B807544716EE1409194C1F3BF4C7371A8DC7DD5D60ECDA1F1302B0429280';
wwv_flow_api.g_varchar2_table(21) := 'D42580CB9B3EB0EE2A770454B4BDEE704D1C009FA91E300F48DD061B7D26740CA6F2B7EECE5E3188D6274F71F3720327C03250ABCDA1AAA6162BC47A1C2C74495727277C651C6ED4FE8C8C8C8C8C3DC7B367F1F252CC6D13985B4EF2B653F974F74B7B9B';
wwv_flow_api.g_varchar2_table(22) := 'FAD2896DB2DDE5D893569E74FB36A1C9E1D2B2527F60FAD4D1FB9ACEB64ED8267DDBF6420955E519189928F2723CF471C881567972D00572412A2ABFDDD8AF10037A670336D344239BB1090597969BF3D159509B60AEECEEEDA5E17682CFE97380E7CC7E';
wwv_flow_api.g_varchar2_table(23) := '13289D7AFB4D6CDE65BF7C75B808CC14FC51BF1E61852A7D9E2B549FCC0DB20380FA93BA527FC6F9ED580B63222B2A9F0C4E906CF49F4EFB14046863BF46740E873C4E2B3B2D7DE8D88C5874D9952480A5C3A05E9CBF7C75768E868D2AEDDF7EC02745C0';
wwv_flow_api.g_varchar2_table(24) := '5FE0AFFA35C206EAD2319371F2A173E3012A9F5205DB60DE4FCE92F69E3911F503237834D51C34C2811BB139E823A0ED05BCACCFFEDFE0995748DB8F86ECD21EF095FA5AFDDD0F295D300FB8601E70C13CA0B5DF9DC11A9A4EAACB6F597BDF34D2379D82';
wwv_flow_api.g_varchar2_table(25) := '3699C7B903983EC0DB9726E0C5F91787FA15B6BF8DD4310125D85127277F05DFEAD73F9C6CDAC3D7B8952B26A3727BFD6AB84E9113E0B2BBAE0FA0E634FC290CDACBC360A84E01E78B8C802EBD0BDBDFAD88A00420F9FCEBC7A3C7FFFCAE958FDCE10E97';
wwv_flow_api.g_varchar2_table(26) := '93A7F4EC297109B432169F3FF7B2F1FD6EBC33488062D01BCCF860EF7D10D820F797ADC2FE2E609618F1F5061D81FA8FA7EC70715931FB65025F62FBD5CBEF75F737F9FE652B4ECDF55F46F61786B6DD28EA4481541383FC2C0EE0C3DE4C0E7D034C4C9E';
wwv_flow_api.g_varchar2_table(27) := '72FBF96D50358BBA7CB19D1178E88AA507318C6385FB8A7820444162A08C8C8C8C8C1D608807A64D280717B1EA37BCB4D04E4544EF7E3C765C09252CF4FB02DF9A2F01859A9FC370F8C30FF01D52E711DE7F7E062F5EC0D9DCC96CBD851B6E70E30D9DCC';
wwv_flow_api.g_varchar2_table(28) := '3774C91B8F9BC6301A0E5F1306B8BDAB1130D5C71AA36C1334030B1E8D9FFAC8EB5F06FFF6A1E862A80F3015C94D57CEA66AD91F6DF2EAEBE8D0B1D2C98E9F1C6C0A7C726502E305BCE6E30D8AC8AB1060422DB487B1DDFE76152E69E8F9E68D526FDE78';
wwv_flow_api.g_varchar2_table(29) := '7D860AEA299ED9E1049025236007A3D08287523543151D01BAAA198F4104BC327375B8C18561BD8F00E01A0873597933BBE73D6A61656F7F49EB379F7EF2F5AD2E1AA17015066C4106DDDFCE83A20A60124F9DCF29EC0193095EAF3E9ECF4D7AE909D0F6';
wwv_flow_api.g_varchar2_table(30) := '2B3404C619E7C94258642E8EC34D7AFECB76CD88EB03BEB5D3CFF0B6AB50D7647F38891370ACFF3C363FAED838D8104E910710FD2A78F5EAE8D51C2EBB03BE36DA8D364700F7801FADEC46E55AFBBD81E385C529DDDD13A64FE9C9C90921A0F96CC5538D';
wwv_flow_api.g_varchar2_table(31) := '73FDD311D068B3E8ED03E6737301E04EF0F57038DA602708B40F30F62F3C03C6FE9AA4A373A3EFA9DF7DF1082E1103E640C7A8DB738337CEBEA74FDB9F56EE0644FAFA8061359FCF618E1900761BDCF45DE0B91998F5FAF0D46D3199F8012BDD03EA9FD2';
wwv_flow_api.g_varchar2_table(32) := '3300E4C3FD79E836F0DBA0F5088B9E3E40DF7535300112EB11C050DA73FFDCC501813582A403313DC6EB123DA70770FDA2202A81C24B56069519D2ABDC828DD5E380DDE3F8DDBB63244E1F19AE34078D28FA58B97232232323632D0CF1EAE8B39F4C17F3';
wwv_flow_api.g_varchar2_table(33) := 'D3D9CEB4D93EDE03BCEF849F5DAFFBF30E35DA2E9E18739FB4C25973C731EFDE076630C33BFC2710CCA81506A6139859FE67E98A9BC27B93403917F8E009F8D0D5606143288EA83D2562EA816FE032CCCC3D1DAD86DE6E9CF2A431F8096A9C871E429F92';
wwv_flow_api.g_varchar2_table(34) := '6FA8BD5324166E1AF9E3E0239D9D15CD6D9300DD039814FA3D699CEA30C11363CADAEFA7178DDDC8FED0D2DD6939C5F67DD46F1F4985D90E09A8DDF9AE71E354879A5DF20057252EC3F687082889CBD885E65D7ADB5CF0788F0A66B3D9F6225D6FB0D727';
wwv_flow_api.g_varchar2_table(35) := '7512D0E4ABB59D748A6B7BC0763B41EB00CD4333D686779E8077A8527F1F5F23F7B158BB0F100CDE2878A7F7D28B2F7125B61312E8F9571BB80BA8FEC5089BC7CC1BDC6870EDC46B5F49F601588AF9C72762A7C9FA2F665816DEFEB24B1DF669B4222323';
wwv_flow_api.g_varchar2_table(36) := '232323E38651434CBC69C088053274E9E80DE0E080CA358FACB64C00300A0801B6ACC415EA5169DE480593323B79D254EA4F6F6B163BD7A218EC0CD9B660F5C31652029AB24E677B7AB479BC022100974B0278B208A2B211B7E7056DEC3F411B280176F8';
wwv_flow_api.g_varchar2_table(37) := 'A355D27E8CB0CE6D054CC02860136F2F216EF2FF07A4B06D0F588A802D7BC076FB008E9DF7015BBE0B802064C777813DC06EE3808C8C8C8C8CFB8DF87364771DE57F15FC7A8ED66EEA28E5F21E7D4FAE798E147EADD1F30CE3FA6DE0010A179BF0EF3F58';
wwv_flow_api.g_varchar2_table(38) := '55DE3B2CE07F9A008556272B13FB0B06807F569F26EF1B4AB852EAD75A5DE1A7AD17A73AA3A5CFD77A43062703FDD32DDF8613BA9EDDC840E581790DF634BCADDA75F397FE0C8DA76056DB9307771001F6ABD18A23F7FD7A504051980D4E3E322FFFFD7B';
wwv_flow_api.g_varchar2_table(39) := 'A65C6F298EF69400EB011A57F88C9B7E618133784CC0770D3A175F51DE3B8CEC3D708AD6BCE8647408A7C31E02EE5C273806B8BABCC2DD7E331CE1535250DB1DA1DA36C6EFF5F9797F2B9F9ACFC8C8C8C8581BFCF98094CC1751AD2AAFDADEBA720AFCF9';
wwv_flow_api.g_varchar2_table(40) := '8094CC97D1AD2AAFDADEBA720A67D0E16C19992FA45C555EB5BD75E524F8F3011FFC019C7C6D62C3EB566E96D2DAF2779D0C5C56BDE51F7CF987DEF61544CBCD8A4E564EE5E610FE798718C037009DEC0EA2DAD9E0EB6B3C3B9CAA2FCB457D3F451E2AC7';
wwv_flow_api.g_varchar2_table(41) := 'B367E14F20FAA8DF7EFB8DE867FE9C2F39BF06AE1E3698CAE6EABD660A6385447D250C8AD7670424F551EEB7479E37F66F8E8029FA0EBA0001A1CF550C4AB61FF0909807986F1B99032C4F40FA1230DFBE155128EDF2C0E41481103B9E62F5B9AC199877';
wwv_flow_api.g_varchar2_table(42) := 'F593E0CF07043A35D709FA4E8C7752C0E5FE4E35D849F2F679274BCB1D3F7DB2B9063A39896DDFC6D6BD8DAE2AA7B1ED4066DD406A55398D6D87B2EB86D2ABCA1919191919191911B481C38DC97B0FF6FF03D3F21D2400E204D897977DF6ED644680E2FF';
wwv_flow_api.g_varchar2_table(43) := 'F470BFD17C252144644610B8B73E99FDFBBB7D47F6807BDF07DCF7BB40464646464646C6A651DC9E4820B90A12AAD517BA16ECFF03ED330A95D0750902F8F9BE4DF66FC203B8BDB7CA7EEA017679BB7DA16D15FB777A3CD837F51595EF6E1F5039F872C6';
wwv_flow_api.g_varchar2_table(44) := '576BFFEDF181753DA0A9AFB07CABEC5FD7036EBDFDEBDE057AECBFB37D4002DEFEDBE303490F5805C66EF79B91B1E7F83FC9E6731C1F3C75500000000049454E44AE426082';
null;
 
end;
/

 
begin
 
wwv_flow_api.create_plugin_file (
  p_id => 14105944050104626 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 14105553394102204 + wwv_flow_api.g_id_offset
 ,p_file_name => 'ui-icons_2e83ff_256x240.png'
 ,p_mime_type => 'image/png'
 ,p_file_content => wwv_flow_api.g_varchar2_table
  );
null;
 
end;
/

 
begin
 
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '89504E470D0A1A0A0000000D4948445200000100000000F00803000000D8494AF9000000ED504C54452222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222';
wwv_flow_api.g_varchar2_table(2) := '22222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222';
wwv_flow_api.g_varchar2_table(3) := '2222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222225D9A11F30000004E74524E5300181032040850BF8399';
wwv_flow_api.g_varchar2_table(4) := '2E2254704066601A12CD0C203C1642484A1E5A2630522C85348781C36AC9CFC738441CBDB97CABB5A58DA9ADB328FD9F24EF0A06028FA36295A1AF6CDF9D463E6E7E916868D248FD00000F8549444154789CED5D8D62DBB61106C948AAE584922D7B69EC';
wwv_flow_api.g_varchar2_table(5) := '5A4B3A67F3926C6BD76EAD9A2DA9D37449D7F5DEFF71068004713F202045B224DBF8644B3E0224EE3E1EC13B009495CAC8C8D8031450EC5A859DA200D87306D656AF8068211498015379BB84300F040345B7307D48B9292DF016E0E616740B6B80ED6FFF';
wwv_flow_api.g_varchar2_table(6) := 'DCAA4B700F9404145C1F52CECFA02080EF2E1B1095458B3708A1BF0A9A1029970C2A563B7EF45065DEE20D4278B0122AF2132C3D247A86A5074414D8BE078410ED03A21E1CAC20FA00C54AB1BDDBEF03D2B8D9BB00BF84B67F17D839EE7B209491919191';
wwv_flow_api.g_varchar2_table(7) := '9191B1C7B8F14870C771105740C4F22232270601F0049FDB131F0F100342FAE85BA524A080204054E0D569BA48D52FE4E162D9A539FA369321A17F58E34871604445A4C72A52CE009680AD0D07480F56219F25D9DA12E30185A23BD0F2D4F0C1EED3E122';
wwv_flow_api.g_varchar2_table(8) := 'A2F1FAE301F20AD9691F90C65DBF0B6464646464646464EC0EEB05FEC9D03479FCB5138F350F20F48F1AF40989526207B91C402894389ADC14DB436487F6C5AAD0DDA1AF2CDC4054814069BCFDD01162048972713061816C0E5821F414B60794FAB01DA0';
wwv_flow_api.g_varchar2_table(9) := 'AF7089F665BA2C09EBDF3D3462145720BC7BA40A35B0ADCDC6AC68757EC0287FC11A51178A5E4081E3F33314DA3DEEA2E916228562FFE4351E5843141B404A1F919D8EB84387AAA4FA8054E9AEEF0237BC7FFA3699919191919191715FB1FEB2D435C30C';
wwv_flow_api.g_varchar2_table(10) := 'A9402C7209C5A1C9A9AA44F3AB29B05403F17C9E4F9C851440E50A4F4E2D11D599CAFDC90904A7F7A592E290FDED07F25B6E40ECD85201BCA19958F414496D038BDD8B280189B5E1A14620CA40943FB1F03D30DE12A00870754C91983B671E24D2E14036';
wwv_flow_api.g_varchar2_table(11) := 'CEB784F4170A844B0307601ACAFD033ED0BFBB20406820D5A3E5FC124B131056806E111512C52261A622AB8F0BF925106C821B402E017689242F81F0555EF4D6100C471707C83A010723609D60A09220807582AC54744BA9111CDE7EE01CC58BC35AA0DD';
wwv_flow_api.g_varchar2_table(12) := 'F9351C54BCBF8925D66BECF578C0AE9F8FC9C8C8C8C8C8D86BDCEC5D5C062AEC51D9C01E9B0D2CD2878B05D2EB4286AA34340BDA4F584BCD7C058A7982CE6783B9C1102B5F134DA4281603FB6CD0BE459E0E4F84FA810A200C5624FB54314258F5F50192';
wwv_flow_api.g_varchar2_table(13) := '0162A22D8A7C3F4020D466F3D542DF5872E0F6252740D2B941025CBA49B4E1B94A2C7D8680424263E1F35C06560AF1CA728DC1A7A3086828D25D7449C8EC5EAA19F311A17DDCC7C5196FCED7A66F0CBE53338309223BA3CFF707CA9910BAECD1C1627DDC';
wwv_flow_api.g_varchar2_table(14) := '129D22DFB009100F97D9297B622491BDA61601A5C61FE2E347771077DDBE8C8C8C8C8CBB8DF296DFC80261879CDE6222DEF029F6EFD35440709A85465F657236104A76D0A8A802E1F60EC1226DE8DEADAC4D2DC19F6437F3EA3694D07880AFAF84CBB036';
wwv_flow_api.g_varchar2_table(15) := '02D3A53B04C8EC852FAFD7F693EC8C10603E4B7204505CC4F616B05F04B8D9EB5E758C312593DB4F15FA54824DB2ADE82EB17DB90496F000511F33E608EAF180B62E1B4ED8B307E4E37D00AB111CA129BD97F03E80F705FBE4FE2DE2778160978FEA9761';
wwv_flow_api.g_varchar2_table(16) := '83F81097C316BF2B737924E380E401CA741D87F89729DC4EAC627F46464646C6FD4265E2846AF9FA0F061A0F6E4E1F8AA1566E348CD5F82C11B9C141132AF59958F1E22ACEC703350618AB07A43ED9E3508B87AA47E685EA610BB68333091ED5F510057B';
wwv_flow_api.g_varchar2_table(17) := 'F66F42880D8B263C14F4944C5B0BA7C4DE4E632E8B99ADC3B6DC693D18C36000E3015140896482AFB50D0ACD8649A8C52E49ABEBBA6CC0081911021003605C74E05B3C2004E8431F6974A134380FC0F934C92D060372C0010C8E8F2BC004CC66B3D8EC91';
wwv_flow_api.g_varchar2_table(18) := 'B1068242908043422018D3D1064D4881096914A4849F18F479000C017D9886DB3EC0C9CD7278A4F189DDFDC413707C7AF83B42C0E3C78F153BE162B175AF8B72028CFD9F6302A84B81B69FFA183474A0061F1BF47AC091311D86477E1CA0B2FEDF11608E';
wwv_flow_api.g_varchar2_table(19) := '8F86D89AC3F903EA4BE0C9137C09CC943E05FABDDBA1B2AF4F24C0D8FFF0ECF37E020AB6416F298AA302A530707A7A0ABD7D001C6906B4FD9800FBD311603B4144C0B9D9FBFCDC6D386E3AC163660EDA4112407337BAC112F0051E9F984C1FEAF7BA8F00';
wwv_flow_api.g_varchar2_table(20) := 'DE201C5AA0062F2E2EC0BBA8F080EA6838D46FFE12B0723F01170DDA0DC5184EC7E3398CF13342E812D21B7E6F5FD8DE012760C00800E201136F7F8480EE704F2D98CB0D3A02B807544716EE1409194C1F3BF4C7371A8DC7DD5D60ECDA1F1302B0429280';
wwv_flow_api.g_varchar2_table(21) := 'D42580CB9B3EB0EE2A770454B4BDEE704D1C009FA91E300F48DD061B7D26740CA6F2B7EECE5E3188D6274F71F3720327C03250ABCDA1AAA6162BC47A1C2C74495727277C651C6ED4FE8C8C8C8C8C3DC7B367F1F252CC6D13985B4EF2B653F974F74B7B9B';
wwv_flow_api.g_varchar2_table(22) := 'FAD2896DB2DDE5D893569E74FB36A1C9E1D2B2527F60FAD4D1FB9ACEB64ED8267DDBF6420955E519189928F2723CF471C881567972D00572412A2ABFDDD8AF10037A670336D344239BB1090597969BF3D159509B60AEECEEEDA5E17682CFE97380E7CC7E';
wwv_flow_api.g_varchar2_table(23) := '13289D7AFB4D6CDE65BF7C75B808CC14FC51BF1E61852A7D9E2B549FCC0DB20380FA93BA527FC6F9ED580B63222B2A9F0C4E906CF49F4EFB14046863BF46740E873C4E2B3B2D7DE8D88C5874D9952480A5C3A05E9CBF7C75768E868D2AEDDF7EC02745C0';
wwv_flow_api.g_varchar2_table(24) := '5FE0AFFA35C206EAD2319371F2A173E3012A9F5205DB60DE4FCE92F69E3911F503237834D51C34C2811BB139E823A0ED05BCACCFFEDFE0995748DB8F86ECD21EF095FA5AFDDD0F295D300FB8601E70C13CA0B5DF9DC11A9A4EAACB6F597BDF34D2379D82';
wwv_flow_api.g_varchar2_table(25) := '3699C7B903983EC0DB9726E0C5F91787FA15B6BF8DD4310125D85127277F05DFEAD73F9C6CDAC3D7B8952B26A3727BFD6AB84E9113E0B2BBAE0FA0E634FC290CDACBC360A84E01E78B8C802EBD0BDBDFAD88A00420F9FCEBC7A3C7FFFCAE958FDCE10E97';
wwv_flow_api.g_varchar2_table(26) := '93A7F4EC297109B432169F3FF7B2F1FD6EBC33488062D01BCCF860EF7D10D820F797ADC2FE2E609618F1F5061D81FA8FA7EC70715931FB65025F62FBD5CBEF75F737F9FE652B4ECDF55F46F61786B6DD28EA4481541383FC2C0EE0C3DE4C0E7D034C4C9E';
wwv_flow_api.g_varchar2_table(27) := '72FBF96D50358BBA7CB19D1178E88AA507318C6385FB8A7820444162A08C8C8C8C8C1D608807A64D280717B1EA37BCB4D04E4544EF7E3C765C09252CF4FB02DF9A2F01859A9FC370F8C30FF01D52E711DE7F7E062F5EC0D9DCC96CBD851B6E70E30D9DCC';
wwv_flow_api.g_varchar2_table(28) := '3774C91B8F9BC6301A0E5F1306B8BDAB1130D5C71AA36C1334030B1E8D9FFAC8EB5F06FFF6A1E862A80F3015C94D57CEA66AD91F6DF2EAEBE8D0B1D2C98E9F1C6C0A7C726502E305BCE6E30D8AC8AB1060422DB487B1DDFE76152E69E8F9E68D526FDE78';
wwv_flow_api.g_varchar2_table(29) := '7D860AEA299ED9E1049025236007A3D08287523543151D01BAAA198F4104BC327375B8C18561BD8F00E01A0873597933BBE73D6A61656F7F49EB379F7EF2F5AD2E1AA17015066C4106DDDFCE83A20A60124F9DCF29EC0193095EAF3E9ECF4D7AE909D0F6';
wwv_flow_api.g_varchar2_table(30) := '2B3404C619E7C94258642E8EC34D7AFECB76CD88EB03BEB5D3CFF0B6AB50D7647F38891370ACFF3C363FAED838D8104E910710FD2A78F5EAE8D51C2EBB03BE36DA8D364700F7801FADEC46E55AFBBD81E385C529DDDD13A64FE9C9C90921A0F96CC5538D';
wwv_flow_api.g_varchar2_table(31) := '73FDD311D068B3E8ED03E6737301E04EF0F57038DA602708B40F30F62F3C03C6FE9AA4A373A3EFA9DF7DF1082E1103E640C7A8DB738337CEBEA74FDB9F56EE0644FAFA8061359FCF618E1900761BDCF45DE0B91998F5FAF0D46D3199F8012BDD03EA9FD2';
wwv_flow_api.g_varchar2_table(32) := '3300E4C3FD79E836F0DBA0F5088B9E3E40DF7535300112EB11C050DA73FFDCC501813582A403313DC6EB123DA70770FDA2202A81C24B56069519D2ABDC828DD5E380DDE3F8DDBB63244E1F19AE34078D28FA58B97232232323632D0CF1EAE8B39F4C17F3';
wwv_flow_api.g_varchar2_table(33) := 'D3D9CEB4D93EDE03BCEF849F5DAFFBF30E35DA2E9E18739FB4C25973C731EFDE076630C33BFC2710CCA81506A6139859FE67E98A9BC27B93403917F8E009F8D0D5606143288EA83D2562EA816FE032CCCC3D1DAD86DE6E9CF2A431F8096A9C871E429F92';
wwv_flow_api.g_varchar2_table(34) := '6FA8BD5324166E1AF9E3E0239D9D15CD6D9300DD039814FA3D699CEA30C11363CADAEFA7178DDDC8FED0D2DD6939C5F67DD46F1F4985D90E09A8DDF9AE71E354879A5DF20057252EC3F687082889CBD885E65D7ADB5CF0788F0A66B3D9F6225D6FB0D727';
wwv_flow_api.g_varchar2_table(35) := '7512D0E4ABB59D748A6B7BC0763B41EB00CD4333D686779E8077A8527F1F5F23F7B158BB0F100CDE2878A7F7D28B2F7125B61312E8F9571BB80BA8FEC5089BC7CC1BDC6870EDC46B5F49F601588AF9C72762A7C9FA2F665816DEFEB24B1DF669B4222323';
wwv_flow_api.g_varchar2_table(36) := '232323E38651434CBC69C088053274E9E80DE0E080CA358FACB64C00300A0801B6ACC415EA5169DE480593323B79D254EA4F6F6B163BD7A218EC0CD9B660F5C31652029AB24E677B7AB479BC022100974B0278B208A2B211B7E7056DEC3F411B280176F8';
wwv_flow_api.g_varchar2_table(37) := 'A355D27E8CB0CE6D054CC02860136F2F216EF2FF07A4B06D0F588A802D7BC076FB008E9DF7015BBE0B802064C777813DC06EE3808C8C8C8C8CFB8DF87364771DE57F15FC7A8ED66EEA28E5F21E7D4FAE798E147EADD1F30CE3FA6DE0010A179BF0EF3F58';
wwv_flow_api.g_varchar2_table(38) := '55DE3B2CE07F9A008556272B13FB0B06807F569F26EF1B4AB852EAD75A5DE1A7AD17A73AA3A5CFD77A43062703FDD32DDF8613BA9EDDC840E581790DF634BCADDA75F397FE0C8DA76056DB9307771001F6ABD18A23F7FD7A504051980D4E3E322FFFFD7B';
wwv_flow_api.g_varchar2_table(39) := 'A65C6F298EF69400EB011A57F88C9B7E618133784CC0770D3A175F51DE3B8CEC3D708AD6BCE8647408A7C31E02EE5C273806B8BABCC2DD7E331CE1535250DB1DA1DA36C6EFF5F9797F2B9F9ACFC8C8C8C8581BFCF98094CC1751AD2AAFDADEBA720AFCF9';
wwv_flow_api.g_varchar2_table(40) := '8094CC97D1AD2AAFDADEBA720A67D0E16C19992FA45C555EB5BD75E524F8F3011FFC019C7C6D62C3EB566E96D2DAF2779D0C5C56BDE51F7CF987DEF61544CBCD8A4E564EE5E610FE798718C037009DEC0EA2DAD9E0EB6B3C3B9CAA2FCB457D3F451E2AC7';
wwv_flow_api.g_varchar2_table(41) := 'B367E14F20FAA8DF7EFB8DE867FE9C2F39BF06AE1E3698CAE6EABD660A6385447D250C8AD7670424F551EEB7479E37F66F8E8029FA0EBA0001A1CF550C4AB61FF0909807986F1B99032C4F40FA1230DFBE155128EDF2C0E41481103B9E62F5B9AC199877';
wwv_flow_api.g_varchar2_table(42) := 'F593E0CF07043A35D709FA4E8C7752C0E5FE4E35D849F2F679274BCB1D3F7DB2B9063A39896DDFC6D6BD8DAE2AA7B1ED4066DD406A55398D6D87B2EB86D2ABCA1919191919191911B481C38DC97B0FF6FF03D3F21D2400E204D897977DF6ED644680E2FF';
wwv_flow_api.g_varchar2_table(43) := 'F470BFD17C252144644610B8B73E99FDFBBB7D47F6807BDF07DCF7BB40464646464646C6A651DC9E4820B90A12AAD517BA16ECFF03ED330A95D0750902F8F9BE4DF66FC203B8BDB7CA7EEA017679BB7DA16D15FB777A3CD837F51595EF6E1F5039F872C6';
wwv_flow_api.g_varchar2_table(44) := '576BFFEDF181753DA0A9AFB07CABEC5FD7036EBDFDEBDE057AECBFB37D4002DEFEDBE303490F5805C66EF79B91B1E7F83FC9E6731C1F3C75500000000049454E44AE426082';
null;
 
end;
/

 
begin
 
wwv_flow_api.create_plugin_file (
  p_id => 14106654264105615 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 14105553394102204 + wwv_flow_api.g_id_offset
 ,p_file_name => 'ui-icons_222222_256x240.png'
 ,p_mime_type => 'image/png'
 ,p_file_content => wwv_flow_api.g_varchar2_table
  );
null;
 
end;
/

 
begin
 
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '89504E470D0A1A0A0000000D4948445200000100000000F00803000000D8494AF9000000ED504C54454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545';
wwv_flow_api.g_varchar2_table(2) := '45454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545';
wwv_flow_api.g_varchar2_table(3) := '45454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454586DAB2C20000004E74524E5300181032040850BF8399';
wwv_flow_api.g_varchar2_table(4) := '2E2254704066601A12CD0C203C1642484A1E5A2630522C85348781C36AC9CFC738441CBDB97CABB5A58DA9ADB328FD9F24EF0A06028FA36295A1AF6CDF9D463E6E7E916868D248FD00000F8549444154789CED5D8D62DBB61106C948AAE584922D7B69EC';
wwv_flow_api.g_varchar2_table(5) := '5A4B3A67F3926C6BD76EAD9A2DA9D37449D7F5DEFF71068004713F202045B224DBF8644B3E0224EE3E1EC13B009495CAC8C8D8031450EC5A859DA200D87306D656AF8068211498015379BB84300F040345B7307D48B9292DF016E0E616740B6B80ED6FFF';
wwv_flow_api.g_varchar2_table(6) := 'DCAA4B700F9404145C1F52CECFA02080EF2E1B1095458B3708A1BF0A9A1029970C2A563B7EF45065DEE20D4278B0122AF2132C3D247A86A5074414D8BE078410ED03A21E1CAC20FA00C54AB1BDDBEF03D2B8D9BB00BF84B67F17D839EE7B209491919191';
wwv_flow_api.g_varchar2_table(7) := '9191B1C7B8F14870C771105740C4F22232270601F0049FDB131F0F100342FAE85BA524A080204054E0D569BA48D52FE4E162D9A539FA369321A17F58E34871604445A4C72A52CE009680AD0D07480F56219F25D9DA12E30185A23BD0F2D4F0C1EED3E122';
wwv_flow_api.g_varchar2_table(8) := 'A2F1FAE301F20AD9691F90C65DBF0B6464646464646464EC0EEB05FEC9D03479FCB5138F350F20F48F1AF40989526207B91C402894389ADC14DB436487F6C5AAD0DDA1AF2CDC4054814069BCFDD01162048972713061816C0E5821F414B60794FAB01DA0';
wwv_flow_api.g_varchar2_table(9) := 'AF7089F665BA2C09EBDF3D3462145720BC7BA40A35B0ADCDC6AC68757EC0287FC11A51178A5E4081E3F33314DA3DEEA2E916228562FFE4351E5843141B404A1F919D8EB84387AAA4FA8054E9AEEF0237BC7FFA3699919191919191715FB1FEB2D435C30C';
wwv_flow_api.g_varchar2_table(10) := 'A9402C7209C5A1C9A9AA44F3AB29B05403F17C9E4F9C851440E50A4F4E2D11D599CAFDC90904A7F7A592E290FDED07F25B6E40ECD85201BCA19958F414496D038BDD8B280189B5E1A14620CA40943FB1F03D30DE12A00870754C91983B671E24D2E14036';
wwv_flow_api.g_varchar2_table(11) := 'CEB784F4170A844B0307601ACAFD033ED0BFBB20406820D5A3E5FC124B131056806E111512C52261A622AB8F0BF925106C821B402E017689242F81F0555EF4D6100C471707C83A010723609D60A09220807582AC54744BA9111CDE7EE01CC58BC35AA0DD';
wwv_flow_api.g_varchar2_table(12) := 'F9351C54BCBF8925D66BECF578C0AE9F8FC9C8C8C8C8C8D86BDCEC5D5C062AEC51D9C01E9B0D2CD2878B05D2EB4286AA34340BDA4F584BCD7C058A7982CE6783B9C1102B5F134DA4281603FB6CD0BE459E0E4F84FA810A200C5624FB54314258F5F50192';
wwv_flow_api.g_varchar2_table(13) := '0162A22D8A7C3F4020D466F3D542DF5872E0F6252740D2B941025CBA49B4E1B94A2C7D8680424263E1F35C06560AF1CA728DC1A7A3086828D25D7449C8EC5EAA19F311A17DDCC7C5196FCED7A66F0CBE53338309223BA3CFF707CA9910BAECD1C1627DDC';
wwv_flow_api.g_varchar2_table(14) := '129D22DFB009100F97D9297B622491BDA61601A5C61FE2E347771077DDBE8C8C8C8C8CBB8DF296DFC80261879CDE6222DEF029F6EFD35440709A85465F657236104A76D0A8A802E1F60EC1226DE8DEADAC4D2DC19F6437F3EA3694D07880AFAF84CBB036';
wwv_flow_api.g_varchar2_table(15) := '02D3A53B04C8EC852FAFD7F693EC8C10603E4B7204505CC4F616B05F04B8D9EB5E758C312593DB4F15FA54824DB2ADE82EB17DB90496F000511F33E608EAF180B62E1B4ED8B307E4E37D00AB111CA129BD97F03E80F705FBE4FE2DE2778160978FEA9761';
wwv_flow_api.g_varchar2_table(16) := '83F81097C316BF2B737924E380E401CA741D87F89729DC4EAC627F46464646C6FD4265E2846AF9FA0F061A0F6E4E1F8AA1566E348CD5F82C11B9C141132AF59958F1E22ACEC703350618AB07A43ED9E3508B87AA47E685EA610BB68333091ED5F510057B';
wwv_flow_api.g_varchar2_table(17) := 'F66F42880D8B263C14F4944C5B0BA7C4DE4E632E8B99ADC3B6DC693D18C36000E3015140896482AFB50D0ACD8649A8C52E49ABEBBA6CC0081911021003605C74E05B3C2004E8431F6974A134380FC0F934C92D060372C0010C8E8F2BC004CC66B3D8EC91';
wwv_flow_api.g_varchar2_table(18) := 'B1068242908043422018D3D1064D4881096914A4849F18F479000C017D9886DB3EC0C9CD7278A4F189DDFDC413707C7AF83B42C0E3C78F153BE162B175AF8B72028CFD9F6302A84B81B69FFA183474A0061F1BF47AC091311D86477E1CA0B2FEDF11608E';
wwv_flow_api.g_varchar2_table(19) := '8F86D89AC3F903EA4BE0C9137C09CC943E05FABDDBA1B2AF4F24C0D8FFF0ECF37E020AB6416F298AA302A530707A7A0ABD7D001C6906B4FD9800FBD311603B4144C0B9D9FBFCDC6D386E3AC163660EDA4112407337BAC112F0051E9F984C1FEAF7BA8F00';
wwv_flow_api.g_varchar2_table(20) := 'DE201C5AA0062F2E2EC0BBA8F080EA6838D46FFE12B0723F01170DDA0DC5184EC7E3398CF13342E812D21B7E6F5FD8DE012760C00800E201136F7F8480EE704F2D98CB0D3A02B807544716EE1409194C1F3BF4C7371A8DC7DD5D60ECDA1F1302B0429280';
wwv_flow_api.g_varchar2_table(21) := 'D42580CB9B3EB0EE2A770454B4BDEE704D1C009FA91E300F48DD061B7D26740CA6F2B7EECE5E3188D6274F71F3720327C03250ABCDA1AAA6162BC47A1C2C74495727277C651C6ED4FE8C8C8C8C8C3DC7B367F1F252CC6D13985B4EF2B653F974F74B7B9B';
wwv_flow_api.g_varchar2_table(22) := 'FAD2896DB2DDE5D893569E74FB36A1C9E1D2B2527F60FAD4D1FB9ACEB64ED8267DDBF6420955E519189928F2723CF471C881567972D00572412A2ABFDDD8AF10037A670336D344239BB1090597969BF3D159509B60AEECEEEDA5E17682CFE97380E7CC7E';
wwv_flow_api.g_varchar2_table(23) := '13289D7AFB4D6CDE65BF7C75B808CC14FC51BF1E61852A7D9E2B549FCC0DB20380FA93BA527FC6F9ED580B63222B2A9F0C4E906CF49F4EFB14046863BF46740E873C4E2B3B2D7DE8D88C5874D9952480A5C3A05E9CBF7C75768E868D2AEDDF7EC02745C0';
wwv_flow_api.g_varchar2_table(24) := '5FE0AFFA35C206EAD2319371F2A173E3012A9F5205DB60DE4FCE92F69E3911F503237834D51C34C2811BB139E823A0ED05BCACCFFEDFE0995748DB8F86ECD21EF095FA5AFDDD0F295D300FB8601E70C13CA0B5DF9DC11A9A4EAACB6F597BDF34D2379D82';
wwv_flow_api.g_varchar2_table(25) := '3699C7B903983EC0DB9726E0C5F91787FA15B6BF8DD4310125D85127277F05DFEAD73F9C6CDAC3D7B8952B26A3727BFD6AB84E9113E0B2BBAE0FA0E634FC290CDACBC360A84E01E78B8C802EBD0BDBDFAD88A00420F9FCEBC7A3C7FFFCAE958FDCE10E97';
wwv_flow_api.g_varchar2_table(26) := '93A7F4EC297109B432169F3FF7B2F1FD6EBC33488062D01BCCF860EF7D10D820F797ADC2FE2E609618F1F5061D81FA8FA7EC70715931FB65025F62FBD5CBEF75F737F9FE652B4ECDF55F46F61786B6DD28EA4481541383FC2C0EE0C3DE4C0E7D034C4C9E';
wwv_flow_api.g_varchar2_table(27) := '72FBF96D50358BBA7CB19D1178E88AA507318C6385FB8A7820444162A08C8C8C8C8C1D608807A64D280717B1EA37BCB4D04E4544EF7E3C765C09252CF4FB02DF9A2F01859A9FC370F8C30FF01D52E711DE7F7E062F5EC0D9DCC96CBD851B6E70E30D9DCC';
wwv_flow_api.g_varchar2_table(28) := '3774C91B8F9BC6301A0E5F1306B8BDAB1130D5C71AA36C1334030B1E8D9FFAC8EB5F06FFF6A1E862A80F3015C94D57CEA66AD91F6DF2EAEBE8D0B1D2C98E9F1C6C0A7C726502E305BCE6E30D8AC8AB1060422DB487B1DDFE76152E69E8F9E68D526FDE78';
wwv_flow_api.g_varchar2_table(29) := '7D860AEA299ED9E1049025236007A3D08287523543151D01BAAA198F4104BC327375B8C18561BD8F00E01A0873597933BBE73D6A61656F7F49EB379F7EF2F5AD2E1AA17015066C4106DDDFCE83A20A60124F9DCF29EC0193095EAF3E9ECF4D7AE909D0F6';
wwv_flow_api.g_varchar2_table(30) := '2B3404C619E7C94258642E8EC34D7AFECB76CD88EB03BEB5D3CFF0B6AB50D7647F38891370ACFF3C363FAED838D8104E910710FD2A78F5EAE8D51C2EBB03BE36DA8D364700F7801FADEC46E55AFBBD81E385C529DDDD13A64FE9C9C90921A0F96CC5538D';
wwv_flow_api.g_varchar2_table(31) := '73FDD311D068B3E8ED03E6737301E04EF0F57038DA602708B40F30F62F3C03C6FE9AA4A373A3EFA9DF7DF1082E1103E640C7A8DB738337CEBEA74FDB9F56EE0644FAFA8061359FCF618E1900761BDCF45DE0B91998F5FAF0D46D3199F8012BDD03EA9FD2';
wwv_flow_api.g_varchar2_table(32) := '3300E4C3FD79E836F0DBA0F5088B9E3E40DF7535300112EB11C050DA73FFDCC501813582A403313DC6EB123DA70770FDA2202A81C24B56069519D2ABDC828DD5E380DDE3F8DDBB63244E1F19AE34078D28FA58B97232232323632D0CF1EAE8B39F4C17F3';
wwv_flow_api.g_varchar2_table(33) := 'D3D9CEB4D93EDE03BCEF849F5DAFFBF30E35DA2E9E18739FB4C25973C731EFDE076630C33BFC2710CCA81506A6139859FE67E98A9BC27B93403917F8E009F8D0D5606143288EA83D2562EA816FE032CCCC3D1DAD86DE6E9CF2A431F8096A9C871E429F92';
wwv_flow_api.g_varchar2_table(34) := '6FA8BD5324166E1AF9E3E0239D9D15CD6D9300DD039814FA3D699CEA30C11363CADAEFA7178DDDC8FED0D2DD6939C5F67DD46F1F4985D90E09A8DDF9AE71E354879A5DF20057252EC3F687082889CBD885E65D7ADB5CF0788F0A66B3D9F6225D6FB0D727';
wwv_flow_api.g_varchar2_table(35) := '7512D0E4ABB59D748A6B7BC0763B41EB00CD4333D686779E8077A8527F1F5F23F7B158BB0F100CDE2878A7F7D28B2F7125B61312E8F9571BB80BA8FEC5089BC7CC1BDC6870EDC46B5F49F601588AF9C72762A7C9FA2F665816DEFEB24B1DF669B4222323';
wwv_flow_api.g_varchar2_table(36) := '232323E38651434CBC69C088053274E9E80DE0E080CA358FACB64C00300A0801B6ACC415EA5169DE480593323B79D254EA4F6F6B163BD7A218EC0CD9B660F5C31652029AB24E677B7AB479BC022100974B0278B208A2B211B7E7056DEC3F411B280176F8';
wwv_flow_api.g_varchar2_table(37) := 'A355D27E8CB0CE6D054CC02860136F2F216EF2FF07A4B06D0F588A802D7BC076FB008E9DF7015BBE0B802064C777813DC06EE3808C8C8C8C8CFB8DF87364771DE57F15FC7A8ED66EEA28E5F21E7D4FAE798E147EADD1F30CE3FA6DE0010A179BF0EF3F58';
wwv_flow_api.g_varchar2_table(38) := '55DE3B2CE07F9A008556272B13FB0B06807F569F26EF1B4AB852EAD75A5DE1A7AD17A73AA3A5CFD77A43062703FDD32DDF8613BA9EDDC840E581790DF634BCADDA75F397FE0C8DA76056DB9307771001F6ABD18A23F7FD7A504051980D4E3E322FFFFD7B';
wwv_flow_api.g_varchar2_table(39) := 'A65C6F298EF69400EB011A57F88C9B7E618133784CC0770D3A175F51DE3B8CEC3D708AD6BCE8647408A7C31E02EE5C273806B8BABCC2DD7E331CE1535250DB1DA1DA36C6EFF5F9797F2B9F9ACFC8C8C8C8581BFCF98094CC1751AD2AAFDADEBA720AFCF9';
wwv_flow_api.g_varchar2_table(40) := '8094CC97D1AD2AAFDADEBA720A67D0E16C19992FA45C555EB5BD75E524F8F3011FFC019C7C6D62C3EB566E96D2DAF2779D0C5C56BDE51F7CF987DEF61544CBCD8A4E564EE5E610FE798718C037009DEC0EA2DAD9E0EB6B3C3B9CAA2FCB457D3F451E2AC7';
wwv_flow_api.g_varchar2_table(41) := 'B367E14F20FAA8DF7EFB8DE867FE9C2F39BF06AE1E3698CAE6EABD660A6385447D250C8AD7670424F551EEB7479E37F66F8E8029FA0EBA0001A1CF550C4AB61FF0909807986F1B99032C4F40FA1230DFBE155128EDF2C0E41481103B9E62F5B9AC199877';
wwv_flow_api.g_varchar2_table(42) := 'F593E0CF07043A35D709FA4E8C7752C0E5FE4E35D849F2F679274BCB1D3F7DB2B9063A39896DDFC6D6BD8DAE2AA7B1ED4066DD406A55398D6D87B2EB86D2ABCA1919191919191911B481C38DC97B0FF6FF03D3F21D2400E204D897977DF6ED644680E2FF';
wwv_flow_api.g_varchar2_table(43) := 'F470BFD17C252144644610B8B73E99FDFBBB7D47F6807BDF07DCF7BB40464646464646C6A651DC9E4820B90A12AAD517BA16ECFF03ED330A95D0750902F8F9BE4DF66FC203B8BDB7CA7EEA017679BB7DA16D15FB777A3CD837F51595EF6E1F5039F872C6';
wwv_flow_api.g_varchar2_table(44) := '576BFFEDF181753DA0A9AFB07CABEC5FD7036EBDFDEBDE057AECBFB37D4002DEFEDBE303490F5805C66EF79B91B1E7F83FC9E6731C1F3C75500000000049454E44AE426082';
null;
 
end;
/

 
begin
 
wwv_flow_api.create_plugin_file (
  p_id => 14107331711106674 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 14105553394102204 + wwv_flow_api.g_id_offset
 ,p_file_name => 'ui-icons_454545_256x240.png'
 ,p_mime_type => 'image/png'
 ,p_file_content => wwv_flow_api.g_varchar2_table
  );
null;
 
end;
/

 
begin
 
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '89504E470D0A1A0A0000000D4948445200000100000000F00803000000D8494AF9000000ED504C54458888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888';
wwv_flow_api.g_varchar2_table(2) := '88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888';
wwv_flow_api.g_varchar2_table(3) := '888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888A085CA7B0000004E74524E5300181032040850BF8399';
wwv_flow_api.g_varchar2_table(4) := '2E2254704066601A12CD0C203C1642484A1E5A2630522C85348781C36AC9CFC738441CBDB97CABB5A58DA9ADB328FD9F24EF0A06028FA36295A1AF6CDF9D463E6E7E916868D248FD00000F8549444154789CED5D8D62DBB61106C948AAE584922D7B69EC';
wwv_flow_api.g_varchar2_table(5) := '5A4B3A67F3926C6BD76EAD9A2DA9D37449D7F5DEFF71068004713F202045B224DBF8644B3E0224EE3E1EC13B009495CAC8C8D8031450EC5A859DA200D87306D656AF8068211498015379BB84300F040345B7307D48B9292DF016E0E616740B6B80ED6FFF';
wwv_flow_api.g_varchar2_table(6) := 'DCAA4B700F9404145C1F52CECFA02080EF2E1B1095458B3708A1BF0A9A1029970C2A563B7EF45065DEE20D4278B0122AF2132C3D247A86A5074414D8BE078410ED03A21E1CAC20FA00C54AB1BDDBEF03D2B8D9BB00BF84B67F17D839EE7B209491919191';
wwv_flow_api.g_varchar2_table(7) := '9191B1C7B8F14870C771105740C4F22232270601F0049FDB131F0F100342FAE85BA524A080204054E0D569BA48D52FE4E162D9A539FA369321A17F58E34871604445A4C72A52CE009680AD0D07480F56219F25D9DA12E30185A23BD0F2D4F0C1EED3E122';
wwv_flow_api.g_varchar2_table(8) := 'A2F1FAE301F20AD9691F90C65DBF0B6464646464646464EC0EEB05FEC9D03479FCB5138F350F20F48F1AF40989526207B91C402894389ADC14DB436487F6C5AAD0DDA1AF2CDC4054814069BCFDD01162048972713061816C0E5821F414B60794FAB01DA0';
wwv_flow_api.g_varchar2_table(9) := 'AF7089F665BA2C09EBDF3D3462145720BC7BA40A35B0ADCDC6AC68757EC0287FC11A51178A5E4081E3F33314DA3DEEA2E916228562FFE4351E5843141B404A1F919D8EB84387AAA4FA8054E9AEEF0237BC7FFA3699919191919191715FB1FEB2D435C30C';
wwv_flow_api.g_varchar2_table(10) := 'A9402C7209C5A1C9A9AA44F3AB29B05403F17C9E4F9C851440E50A4F4E2D11D599CAFDC90904A7F7A592E290FDED07F25B6E40ECD85201BCA19958F414496D038BDD8B280189B5E1A14620CA40943FB1F03D30DE12A00870754C91983B671E24D2E14036';
wwv_flow_api.g_varchar2_table(11) := 'CEB784F4170A844B0307601ACAFD033ED0BFBB20406820D5A3E5FC124B131056806E111512C52261A622AB8F0BF925106C821B402E017689242F81F0555EF4D6100C471707C83A010723609D60A09220807582AC54744BA9111CDE7EE01CC58BC35AA0DD';
wwv_flow_api.g_varchar2_table(12) := 'F9351C54BCBF8925D66BECF578C0AE9F8FC9C8C8C8C8C8D86BDCEC5D5C062AEC51D9C01E9B0D2CD2878B05D2EB4286AA34340BDA4F584BCD7C058A7982CE6783B9C1102B5F134DA4281603FB6CD0BE459E0E4F84FA810A200C5624FB54314258F5F50192';
wwv_flow_api.g_varchar2_table(13) := '0162A22D8A7C3F4020D466F3D542DF5872E0F6252740D2B941025CBA49B4E1B94A2C7D8680424263E1F35C06560AF1CA728DC1A7A3086828D25D7449C8EC5EAA19F311A17DDCC7C5196FCED7A66F0CBE53338309223BA3CFF707CA9910BAECD1C1627DDC';
wwv_flow_api.g_varchar2_table(14) := '129D22DFB009100F97D9297B622491BDA61601A5C61FE2E347771077DDBE8C8C8C8C8CBB8DF296DFC80261879CDE6222DEF029F6EFD35440709A85465F657236104A76D0A8A802E1F60EC1226DE8DEADAC4D2DC19F6437F3EA3694D07880AFAF84CBB036';
wwv_flow_api.g_varchar2_table(15) := '02D3A53B04C8EC852FAFD7F693EC8C10603E4B7204505CC4F616B05F04B8D9EB5E758C312593DB4F15FA54824DB2ADE82EB17DB90496F000511F33E608EAF180B62E1B4ED8B307E4E37D00AB111CA129BD97F03E80F705FBE4FE2DE2778160978FEA9761';
wwv_flow_api.g_varchar2_table(16) := '83F81097C316BF2B737924E380E401CA741D87F89729DC4EAC627F46464646C6FD4265E2846AF9FA0F061A0F6E4E1F8AA1566E348CD5F82C11B9C141132AF59958F1E22ACEC703350618AB07A43ED9E3508B87AA47E685EA610BB68333091ED5F510057B';
wwv_flow_api.g_varchar2_table(17) := 'F66F42880D8B263C14F4944C5B0BA7C4DE4E632E8B99ADC3B6DC693D18C36000E3015140896482AFB50D0ACD8649A8C52E49ABEBBA6CC0081911021003605C74E05B3C2004E8431F6974A134380FC0F934C92D060372C0010C8E8F2BC004CC66B3D8EC91';
wwv_flow_api.g_varchar2_table(18) := 'B1068242908043422018D3D1064D4881096914A4849F18F479000C017D9886DB3EC0C9CD7278A4F189DDFDC413707C7AF83B42C0E3C78F153BE162B175AF8B72028CFD9F6302A84B81B69FFA183474A0061F1BF47AC091311D86477E1CA0B2FEDF11608E';
wwv_flow_api.g_varchar2_table(19) := '8F86D89AC3F903EA4BE0C9137C09CC943E05FABDDBA1B2AF4F24C0D8FFF0ECF37E020AB6416F298AA302A530707A7A0ABD7D001C6906B4FD9800FBD311603B4144C0B9D9FBFCDC6D386E3AC163660EDA4112407337BAC112F0051E9F984C1FEAF7BA8F00';
wwv_flow_api.g_varchar2_table(20) := 'DE201C5AA0062F2E2EC0BBA8F080EA6838D46FFE12B0723F01170DDA0DC5184EC7E3398CF13342E812D21B7E6F5FD8DE012760C00800E201136F7F8480EE704F2D98CB0D3A02B807544716EE1409194C1F3BF4C7371A8DC7DD5D60ECDA1F1302B0429280';
wwv_flow_api.g_varchar2_table(21) := 'D42580CB9B3EB0EE2A770454B4BDEE704D1C009FA91E300F48DD061B7D26740CA6F2B7EECE5E3188D6274F71F3720327C03250ABCDA1AAA6162BC47A1C2C74495727277C651C6ED4FE8C8C8C8C8C3DC7B367F1F252CC6D13985B4EF2B653F974F74B7B9B';
wwv_flow_api.g_varchar2_table(22) := 'FAD2896DB2DDE5D893569E74FB36A1C9E1D2B2527F60FAD4D1FB9ACEB64ED8267DDBF6420955E519189928F2723CF471C881567972D00572412A2ABFDDD8AF10037A670336D344239BB1090597969BF3D159509B60AEECEEEDA5E17682CFE97380E7CC7E';
wwv_flow_api.g_varchar2_table(23) := '13289D7AFB4D6CDE65BF7C75B808CC14FC51BF1E61852A7D9E2B549FCC0DB20380FA93BA527FC6F9ED580B63222B2A9F0C4E906CF49F4EFB14046863BF46740E873C4E2B3B2D7DE8D88C5874D9952480A5C3A05E9CBF7C75768E868D2AEDDF7EC02745C0';
wwv_flow_api.g_varchar2_table(24) := '5FE0AFFA35C206EAD2319371F2A173E3012A9F5205DB60DE4FCE92F69E3911F503237834D51C34C2811BB139E823A0ED05BCACCFFEDFE0995748DB8F86ECD21EF095FA5AFDDD0F295D300FB8601E70C13CA0B5DF9DC11A9A4EAACB6F597BDF34D2379D82';
wwv_flow_api.g_varchar2_table(25) := '3699C7B903983EC0DB9726E0C5F91787FA15B6BF8DD4310125D85127277F05DFEAD73F9C6CDAC3D7B8952B26A3727BFD6AB84E9113E0B2BBAE0FA0E634FC290CDACBC360A84E01E78B8C802EBD0BDBDFAD88A00420F9FCEBC7A3C7FFFCAE958FDCE10E97';
wwv_flow_api.g_varchar2_table(26) := '93A7F4EC297109B432169F3FF7B2F1FD6EBC33488062D01BCCF860EF7D10D820F797ADC2FE2E609618F1F5061D81FA8FA7EC70715931FB65025F62FBD5CBEF75F737F9FE652B4ECDF55F46F61786B6DD28EA4481541383FC2C0EE0C3DE4C0E7D034C4C9E';
wwv_flow_api.g_varchar2_table(27) := '72FBF96D50358BBA7CB19D1178E88AA507318C6385FB8A7820444162A08C8C8C8C8C1D608807A64D280717B1EA37BCB4D04E4544EF7E3C765C09252CF4FB02DF9A2F01859A9FC370F8C30FF01D52E711DE7F7E062F5EC0D9DCC96CBD851B6E70E30D9DCC';
wwv_flow_api.g_varchar2_table(28) := '3774C91B8F9BC6301A0E5F1306B8BDAB1130D5C71AA36C1334030B1E8D9FFAC8EB5F06FFF6A1E862A80F3015C94D57CEA66AD91F6DF2EAEBE8D0B1D2C98E9F1C6C0A7C726502E305BCE6E30D8AC8AB1060422DB487B1DDFE76152E69E8F9E68D526FDE78';
wwv_flow_api.g_varchar2_table(29) := '7D860AEA299ED9E1049025236007A3D08287523543151D01BAAA198F4104BC327375B8C18561BD8F00E01A0873597933BBE73D6A61656F7F49EB379F7EF2F5AD2E1AA17015066C4106DDDFCE83A20A60124F9DCF29EC0193095EAF3E9ECF4D7AE909D0F6';
wwv_flow_api.g_varchar2_table(30) := '2B3404C619E7C94258642E8EC34D7AFECB76CD88EB03BEB5D3CFF0B6AB50D7647F38891370ACFF3C363FAED838D8104E910710FD2A78F5EAE8D51C2EBB03BE36DA8D364700F7801FADEC46E55AFBBD81E385C529DDDD13A64FE9C9C90921A0F96CC5538D';
wwv_flow_api.g_varchar2_table(31) := '73FDD311D068B3E8ED03E6737301E04EF0F57038DA602708B40F30F62F3C03C6FE9AA4A373A3EFA9DF7DF1082E1103E640C7A8DB738337CEBEA74FDB9F56EE0644FAFA8061359FCF618E1900761BDCF45DE0B91998F5FAF0D46D3199F8012BDD03EA9FD2';
wwv_flow_api.g_varchar2_table(32) := '3300E4C3FD79E836F0DBA0F5088B9E3E40DF7535300112EB11C050DA73FFDCC501813582A403313DC6EB123DA70770FDA2202A81C24B56069519D2ABDC828DD5E380DDE3F8DDBB63244E1F19AE34078D28FA58B97232232323632D0CF1EAE8B39F4C17F3';
wwv_flow_api.g_varchar2_table(33) := 'D3D9CEB4D93EDE03BCEF849F5DAFFBF30E35DA2E9E18739FB4C25973C731EFDE076630C33BFC2710CCA81506A6139859FE67E98A9BC27B93403917F8E009F8D0D5606143288EA83D2562EA816FE032CCCC3D1DAD86DE6E9CF2A431F8096A9C871E429F92';
wwv_flow_api.g_varchar2_table(34) := '6FA8BD5324166E1AF9E3E0239D9D15CD6D9300DD039814FA3D699CEA30C11363CADAEFA7178DDDC8FED0D2DD6939C5F67DD46F1F4985D90E09A8DDF9AE71E354879A5DF20057252EC3F687082889CBD885E65D7ADB5CF0788F0A66B3D9F6225D6FB0D727';
wwv_flow_api.g_varchar2_table(35) := '7512D0E4ABB59D748A6B7BC0763B41EB00CD4333D686779E8077A8527F1F5F23F7B158BB0F100CDE2878A7F7D28B2F7125B61312E8F9571BB80BA8FEC5089BC7CC1BDC6870EDC46B5F49F601588AF9C72762A7C9FA2F665816DEFEB24B1DF669B4222323';
wwv_flow_api.g_varchar2_table(36) := '232323E38651434CBC69C088053274E9E80DE0E080CA358FACB64C00300A0801B6ACC415EA5169DE480593323B79D254EA4F6F6B163BD7A218EC0CD9B660F5C31652029AB24E677B7AB479BC022100974B0278B208A2B211B7E7056DEC3F411B280176F8';
wwv_flow_api.g_varchar2_table(37) := 'A355D27E8CB0CE6D054CC02860136F2F216EF2FF07A4B06D0F588A802D7BC076FB008E9DF7015BBE0B802064C777813DC06EE3808C8C8C8C8CFB8DF87364771DE57F15FC7A8ED66EEA28E5F21E7D4FAE798E147EADD1F30CE3FA6DE0010A179BF0EF3F58';
wwv_flow_api.g_varchar2_table(38) := '55DE3B2CE07F9A008556272B13FB0B06807F569F26EF1B4AB852EAD75A5DE1A7AD17A73AA3A5CFD77A43062703FDD32DDF8613BA9EDDC840E581790DF634BCADDA75F397FE0C8DA76056DB9307771001F6ABD18A23F7FD7A504051980D4E3E322FFFFD7B';
wwv_flow_api.g_varchar2_table(39) := 'A65C6F298EF69400EB011A57F88C9B7E618133784CC0770D3A175F51DE3B8CEC3D708AD6BCE8647408A7C31E02EE5C273806B8BABCC2DD7E331CE1535250DB1DA1DA36C6EFF5F9797F2B9F9ACFC8C8C8C8581BFCF98094CC1751AD2AAFDADEBA720AFCF9';
wwv_flow_api.g_varchar2_table(40) := '8094CC97D1AD2AAFDADEBA720A67D0E16C19992FA45C555EB5BD75E524F8F3011FFC019C7C6D62C3EB566E96D2DAF2779D0C5C56BDE51F7CF987DEF61544CBCD8A4E564EE5E610FE798718C037009DEC0EA2DAD9E0EB6B3C3B9CAA2FCB457D3F451E2AC7';
wwv_flow_api.g_varchar2_table(41) := 'B367E14F20FAA8DF7EFB8DE867FE9C2F39BF06AE1E3698CAE6EABD660A6385447D250C8AD7670424F551EEB7479E37F66F8E8029FA0EBA0001A1CF550C4AB61FF0909807986F1B99032C4F40FA1230DFBE155128EDF2C0E41481103B9E62F5B9AC199877';
wwv_flow_api.g_varchar2_table(42) := 'F593E0CF07043A35D709FA4E8C7752C0E5FE4E35D849F2F679274BCB1D3F7DB2B9063A39896DDFC6D6BD8DAE2AA7B1ED4066DD406A55398D6D87B2EB86D2ABCA1919191919191911B481C38DC97B0FF6FF03D3F21D2400E204D897977DF6ED644680E2FF';
wwv_flow_api.g_varchar2_table(43) := 'F470BFD17C252144644610B8B73E99FDFBBB7D47F6807BDF07DCF7BB40464646464646C6A651DC9E4820B90A12AAD517BA16ECFF03ED330A95D0750902F8F9BE4DF66FC203B8BDB7CA7EEA017679BB7DA16D15FB777A3CD837F51595EF6E1F5039F872C6';
wwv_flow_api.g_varchar2_table(44) := '576BFFEDF181753DA0A9AFB07CABEC5FD7036EBDFDEBDE057AECBFB37D4002DEFEDBE303490F5805C66EF79B91B1E7F83FC9E6731C1F3C75500000000049454E44AE426082';
null;
 
end;
/

 
begin
 
wwv_flow_api.create_plugin_file (
  p_id => 14108041926107607 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 14105553394102204 + wwv_flow_api.g_id_offset
 ,p_file_name => 'ui-icons_888888_256x240.png'
 ,p_mime_type => 'image/png'
 ,p_file_content => wwv_flow_api.g_varchar2_table
  );
null;
 
end;
/

 
begin
 
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '89504E470D0A1A0A0000000D4948445200000100000000F00803000000D8494AF9000000ED504C5445CD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A';
wwv_flow_api.g_varchar2_table(2) := '0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0A';
wwv_flow_api.g_varchar2_table(3) := 'CD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0ACD0A0AEA3798FC0000004E74524E5300181032040850BF8399';
wwv_flow_api.g_varchar2_table(4) := '2E2254704066601A12CD0C203C1642484A1E5A2630522C85348781C36AC9CFC738441CBDB97CABB5A58DA9ADB328FD9F24EF0A06028FA36295A1AF6CDF9D463E6E7E916868D248FD00000F8549444154789CED5D8D62DBB61106C948AAE584922D7B69EC';
wwv_flow_api.g_varchar2_table(5) := '5A4B3A67F3926C6BD76EAD9A2DA9D37449D7F5DEFF71068004713F202045B224DBF8644B3E0224EE3E1EC13B009495CAC8C8D8031450EC5A859DA200D87306D656AF8068211498015379BB84300F040345B7307D48B9292DF016E0E616740B6B80ED6FFF';
wwv_flow_api.g_varchar2_table(6) := 'DCAA4B700F9404145C1F52CECFA02080EF2E1B1095458B3708A1BF0A9A1029970C2A563B7EF45065DEE20D4278B0122AF2132C3D247A86A5074414D8BE078410ED03A21E1CAC20FA00C54AB1BDDBEF03D2B8D9BB00BF84B67F17D839EE7B209491919191';
wwv_flow_api.g_varchar2_table(7) := '9191B1C7B8F14870C771105740C4F22232270601F0049FDB131F0F100342FAE85BA524A080204054E0D569BA48D52FE4E162D9A539FA369321A17F58E34871604445A4C72A52CE009680AD0D07480F56219F25D9DA12E30185A23BD0F2D4F0C1EED3E122';
wwv_flow_api.g_varchar2_table(8) := 'A2F1FAE301F20AD9691F90C65DBF0B6464646464646464EC0EEB05FEC9D03479FCB5138F350F20F48F1AF40989526207B91C402894389ADC14DB436487F6C5AAD0DDA1AF2CDC4054814069BCFDD01162048972713061816C0E5821F414B60794FAB01DA0';
wwv_flow_api.g_varchar2_table(9) := 'AF7089F665BA2C09EBDF3D3462145720BC7BA40A35B0ADCDC6AC68757EC0287FC11A51178A5E4081E3F33314DA3DEEA2E916228562FFE4351E5843141B404A1F919D8EB84387AAA4FA8054E9AEEF0237BC7FFA3699919191919191715FB1FEB2D435C30C';
wwv_flow_api.g_varchar2_table(10) := 'A9402C7209C5A1C9A9AA44F3AB29B05403F17C9E4F9C851440E50A4F4E2D11D599CAFDC90904A7F7A592E290FDED07F25B6E40ECD85201BCA19958F414496D038BDD8B280189B5E1A14620CA40943FB1F03D30DE12A00870754C91983B671E24D2E14036';
wwv_flow_api.g_varchar2_table(11) := 'CEB784F4170A844B0307601ACAFD033ED0BFBB20406820D5A3E5FC124B131056806E111512C52261A622AB8F0BF925106C821B402E017689242F81F0555EF4D6100C471707C83A010723609D60A09220807582AC54744BA9111CDE7EE01CC58BC35AA0DD';
wwv_flow_api.g_varchar2_table(12) := 'F9351C54BCBF8925D66BECF578C0AE9F8FC9C8C8C8C8C8D86BDCEC5D5C062AEC51D9C01E9B0D2CD2878B05D2EB4286AA34340BDA4F584BCD7C058A7982CE6783B9C1102B5F134DA4281603FB6CD0BE459E0E4F84FA810A200C5624FB54314258F5F50192';
wwv_flow_api.g_varchar2_table(13) := '0162A22D8A7C3F4020D466F3D542DF5872E0F6252740D2B941025CBA49B4E1B94A2C7D8680424263E1F35C06560AF1CA728DC1A7A3086828D25D7449C8EC5EAA19F311A17DDCC7C5196FCED7A66F0CBE53338309223BA3CFF707CA9910BAECD1C1627DDC';
wwv_flow_api.g_varchar2_table(14) := '129D22DFB009100F97D9297B622491BDA61601A5C61FE2E347771077DDBE8C8C8C8C8CBB8DF296DFC80261879CDE6222DEF029F6EFD35440709A85465F657236104A76D0A8A802E1F60EC1226DE8DEADAC4D2DC19F6437F3EA3694D07880AFAF84CBB036';
wwv_flow_api.g_varchar2_table(15) := '02D3A53B04C8EC852FAFD7F693EC8C10603E4B7204505CC4F616B05F04B8D9EB5E758C312593DB4F15FA54824DB2ADE82EB17DB90496F000511F33E608EAF180B62E1B4ED8B307E4E37D00AB111CA129BD97F03E80F705FBE4FE2DE2778160978FEA9761';
wwv_flow_api.g_varchar2_table(16) := '83F81097C316BF2B737924E380E401CA741D87F89729DC4EAC627F46464646C6FD4265E2846AF9FA0F061A0F6E4E1F8AA1566E348CD5F82C11B9C141132AF59958F1E22ACEC703350618AB07A43ED9E3508B87AA47E685EA610BB68333091ED5F510057B';
wwv_flow_api.g_varchar2_table(17) := 'F66F42880D8B263C14F4944C5B0BA7C4DE4E632E8B99ADC3B6DC693D18C36000E3015140896482AFB50D0ACD8649A8C52E49ABEBBA6CC0081911021003605C74E05B3C2004E8431F6974A134380FC0F934C92D060372C0010C8E8F2BC004CC66B3D8EC91';
wwv_flow_api.g_varchar2_table(18) := 'B1068242908043422018D3D1064D4881096914A4849F18F479000C017D9886DB3EC0C9CD7278A4F189DDFDC413707C7AF83B42C0E3C78F153BE162B175AF8B72028CFD9F6302A84B81B69FFA183474A0061F1BF47AC091311D86477E1CA0B2FEDF11608E';
wwv_flow_api.g_varchar2_table(19) := '8F86D89AC3F903EA4BE0C9137C09CC943E05FABDDBA1B2AF4F24C0D8FFF0ECF37E020AB6416F298AA302A530707A7A0ABD7D001C6906B4FD9800FBD311603B4144C0B9D9FBFCDC6D386E3AC163660EDA4112407337BAC112F0051E9F984C1FEAF7BA8F00';
wwv_flow_api.g_varchar2_table(20) := 'DE201C5AA0062F2E2EC0BBA8F080EA6838D46FFE12B0723F01170DDA0DC5184EC7E3398CF13342E812D21B7E6F5FD8DE012760C00800E201136F7F8480EE704F2D98CB0D3A02B807544716EE1409194C1F3BF4C7371A8DC7DD5D60ECDA1F1302B0429280';
wwv_flow_api.g_varchar2_table(21) := 'D42580CB9B3EB0EE2A770454B4BDEE704D1C009FA91E300F48DD061B7D26740CA6F2B7EECE5E3188D6274F71F3720327C03250ABCDA1AAA6162BC47A1C2C74495727277C651C6ED4FE8C8C8C8C8C3DC7B367F1F252CC6D13985B4EF2B653F974F74B7B9B';
wwv_flow_api.g_varchar2_table(22) := 'FAD2896DB2DDE5D893569E74FB36A1C9E1D2B2527F60FAD4D1FB9ACEB64ED8267DDBF6420955E519189928F2723CF471C881567972D00572412A2ABFDDD8AF10037A670336D344239BB1090597969BF3D159509B60AEECEEEDA5E17682CFE97380E7CC7E';
wwv_flow_api.g_varchar2_table(23) := '13289D7AFB4D6CDE65BF7C75B808CC14FC51BF1E61852A7D9E2B549FCC0DB20380FA93BA527FC6F9ED580B63222B2A9F0C4E906CF49F4EFB14046863BF46740E873C4E2B3B2D7DE8D88C5874D9952480A5C3A05E9CBF7C75768E868D2AEDDF7EC02745C0';
wwv_flow_api.g_varchar2_table(24) := '5FE0AFFA35C206EAD2319371F2A173E3012A9F5205DB60DE4FCE92F69E3911F503237834D51C34C2811BB139E823A0ED05BCACCFFEDFE0995748DB8F86ECD21EF095FA5AFDDD0F295D300FB8601E70C13CA0B5DF9DC11A9A4EAACB6F597BDF34D2379D82';
wwv_flow_api.g_varchar2_table(25) := '3699C7B903983EC0DB9726E0C5F91787FA15B6BF8DD4310125D85127277F05DFEAD73F9C6CDAC3D7B8952B26A3727BFD6AB84E9113E0B2BBAE0FA0E634FC290CDACBC360A84E01E78B8C802EBD0BDBDFAD88A00420F9FCEBC7A3C7FFFCAE958FDCE10E97';
wwv_flow_api.g_varchar2_table(26) := '93A7F4EC297109B432169F3FF7B2F1FD6EBC33488062D01BCCF860EF7D10D820F797ADC2FE2E609618F1F5061D81FA8FA7EC70715931FB65025F62FBD5CBEF75F737F9FE652B4ECDF55F46F61786B6DD28EA4481541383FC2C0EE0C3DE4C0E7D034C4C9E';
wwv_flow_api.g_varchar2_table(27) := '72FBF96D50358BBA7CB19D1178E88AA507318C6385FB8A7820444162A08C8C8C8C8C1D608807A64D280717B1EA37BCB4D04E4544EF7E3C765C09252CF4FB02DF9A2F01859A9FC370F8C30FF01D52E711DE7F7E062F5EC0D9DCC96CBD851B6E70E30D9DCC';
wwv_flow_api.g_varchar2_table(28) := '3774C91B8F9BC6301A0E5F1306B8BDAB1130D5C71AA36C1334030B1E8D9FFAC8EB5F06FFF6A1E862A80F3015C94D57CEA66AD91F6DF2EAEBE8D0B1D2C98E9F1C6C0A7C726502E305BCE6E30D8AC8AB1060422DB487B1DDFE76152E69E8F9E68D526FDE78';
wwv_flow_api.g_varchar2_table(29) := '7D860AEA299ED9E1049025236007A3D08287523543151D01BAAA198F4104BC327375B8C18561BD8F00E01A0873597933BBE73D6A61656F7F49EB379F7EF2F5AD2E1AA17015066C4106DDDFCE83A20A60124F9DCF29EC0193095EAF3E9ECF4D7AE909D0F6';
wwv_flow_api.g_varchar2_table(30) := '2B3404C619E7C94258642E8EC34D7AFECB76CD88EB03BEB5D3CFF0B6AB50D7647F38891370ACFF3C363FAED838D8104E910710FD2A78F5EAE8D51C2EBB03BE36DA8D364700F7801FADEC46E55AFBBD81E385C529DDDD13A64FE9C9C90921A0F96CC5538D';
wwv_flow_api.g_varchar2_table(31) := '73FDD311D068B3E8ED03E6737301E04EF0F57038DA602708B40F30F62F3C03C6FE9AA4A373A3EFA9DF7DF1082E1103E640C7A8DB738337CEBEA74FDB9F56EE0644FAFA8061359FCF618E1900761BDCF45DE0B91998F5FAF0D46D3199F8012BDD03EA9FD2';
wwv_flow_api.g_varchar2_table(32) := '3300E4C3FD79E836F0DBA0F5088B9E3E40DF7535300112EB11C050DA73FFDCC501813582A403313DC6EB123DA70770FDA2202A81C24B56069519D2ABDC828DD5E380DDE3F8DDBB63244E1F19AE34078D28FA58B97232232323632D0CF1EAE8B39F4C17F3';
wwv_flow_api.g_varchar2_table(33) := 'D3D9CEB4D93EDE03BCEF849F5DAFFBF30E35DA2E9E18739FB4C25973C731EFDE076630C33BFC2710CCA81506A6139859FE67E98A9BC27B93403917F8E009F8D0D5606143288EA83D2562EA816FE032CCCC3D1DAD86DE6E9CF2A431F8096A9C871E429F92';
wwv_flow_api.g_varchar2_table(34) := '6FA8BD5324166E1AF9E3E0239D9D15CD6D9300DD039814FA3D699CEA30C11363CADAEFA7178DDDC8FED0D2DD6939C5F67DD46F1F4985D90E09A8DDF9AE71E354879A5DF20057252EC3F687082889CBD885E65D7ADB5CF0788F0A66B3D9F6225D6FB0D727';
wwv_flow_api.g_varchar2_table(35) := '7512D0E4ABB59D748A6B7BC0763B41EB00CD4333D686779E8077A8527F1F5F23F7B158BB0F100CDE2878A7F7D28B2F7125B61312E8F9571BB80BA8FEC5089BC7CC1BDC6870EDC46B5F49F601588AF9C72762A7C9FA2F665816DEFEB24B1DF669B4222323';
wwv_flow_api.g_varchar2_table(36) := '232323E38651434CBC69C088053274E9E80DE0E080CA358FACB64C00300A0801B6ACC415EA5169DE480593323B79D254EA4F6F6B163BD7A218EC0CD9B660F5C31652029AB24E677B7AB479BC022100974B0278B208A2B211B7E7056DEC3F411B280176F8';
wwv_flow_api.g_varchar2_table(37) := 'A355D27E8CB0CE6D054CC02860136F2F216EF2FF07A4B06D0F588A802D7BC076FB008E9DF7015BBE0B802064C777813DC06EE3808C8C8C8C8CFB8DF87364771DE57F15FC7A8ED66EEA28E5F21E7D4FAE798E147EADD1F30CE3FA6DE0010A179BF0EF3F58';
wwv_flow_api.g_varchar2_table(38) := '55DE3B2CE07F9A008556272B13FB0B06807F569F26EF1B4AB852EAD75A5DE1A7AD17A73AA3A5CFD77A43062703FDD32DDF8613BA9EDDC840E581790DF634BCADDA75F397FE0C8DA76056DB9307771001F6ABD18A23F7FD7A504051980D4E3E322FFFFD7B';
wwv_flow_api.g_varchar2_table(39) := 'A65C6F298EF69400EB011A57F88C9B7E618133784CC0770D3A175F51DE3B8CEC3D708AD6BCE8647408A7C31E02EE5C273806B8BABCC2DD7E331CE1535250DB1DA1DA36C6EFF5F9797F2B9F9ACFC8C8C8C8581BFCF98094CC1751AD2AAFDADEBA720AFCF9';
wwv_flow_api.g_varchar2_table(40) := '8094CC97D1AD2AAFDADEBA720A67D0E16C19992FA45C555EB5BD75E524F8F3011FFC019C7C6D62C3EB566E96D2DAF2779D0C5C56BDE51F7CF987DEF61544CBCD8A4E564EE5E610FE798718C037009DEC0EA2DAD9E0EB6B3C3B9CAA2FCB457D3F451E2AC7';
wwv_flow_api.g_varchar2_table(41) := 'B367E14F20FAA8DF7EFB8DE867FE9C2F39BF06AE1E3698CAE6EABD660A6385447D250C8AD7670424F551EEB7479E37F66F8E8029FA0EBA0001A1CF550C4AB61FF0909807986F1B99032C4F40FA1230DFBE155128EDF2C0E41481103B9E62F5B9AC199877';
wwv_flow_api.g_varchar2_table(42) := 'F593E0CF07043A35D709FA4E8C7752C0E5FE4E35D849F2F679274BCB1D3F7DB2B9063A39896DDFC6D6BD8DAE2AA7B1ED4066DD406A55398D6D87B2EB86D2ABCA1919191919191911B481C38DC97B0FF6FF03D3F21D2400E204D897977DF6ED644680E2FF';
wwv_flow_api.g_varchar2_table(43) := 'F470BFD17C252144644610B8B73E99FDFBBB7D47F6807BDF07DCF7BB40464646464646C6A651DC9E4820B90A12AAD517BA16ECFF03ED330A95D0750902F8F9BE4DF66FC203B8BDB7CA7EEA017679BB7DA16D15FB777A3CD837F51595EF6E1F5039F872C6';
wwv_flow_api.g_varchar2_table(44) := '576BFFEDF181753DA0A9AFB07CABEC5FD7036EBDFDEBDE057AECBFB37D4002DEFEDBE303490F5805C66EF79B91B1E7F83FC9E6731C1F3C75500000000049454E44AE426082';
null;
 
end;
/

 
begin
 
wwv_flow_api.create_plugin_file (
  p_id => 14108730437108421 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 14105553394102204 + wwv_flow_api.g_id_offset
 ,p_file_name => 'ui-icons_cd0a0a_256x240.png'
 ,p_mime_type => 'image/png'
 ,p_file_content => wwv_flow_api.g_varchar2_table
  );
null;
 
end;
/

 
begin
 
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '66756E6374696F6E204669784F766572666C6F7748696464656E28704974656D496429207B0D0A0D0A09617065782E6A517565727928222322202B20704974656D4964292E706172656E747328292E63737328226F766572666C6F77222C227669736962';
wwv_flow_api.g_varchar2_table(2) := '6C6522293B0D0A7D0D0A0D0A66756E6374696F6E206D695F6F7074696F6E5F696E6974282070446973706C6179426C6F636B49642C20704D656E7549642C20704974656D49642C207053656C6563744D656E754F7074696F6E2C20704163746976655468';
wwv_flow_api.g_varchar2_table(3) := '656D65436C6173732C2070446973706C6179466F726D61742C2070416A61784964656E7469666965722C2070506172656E744974656D732C20704974656D73746F5375626D69742029207B0D0A090D0A092F2F2073656C656374206D656E75206F707469';
wwv_flow_api.g_varchar2_table(4) := '6F6E0D0A09617065782E6A517565727928222322202B20704D656E754964202B2022202E6D692D6D656E752D6F7074696F6E22292E636C69636B282066756E6374696F6E286576656E7429207B0D0A0D0A09096C52657475726E49642020203D20617065';
wwv_flow_api.g_varchar2_table(5) := '782E6A51756572792874686973292E61747472282272657475726E696422293B0D0A09096C416374696F6E54797065203D20617065782E6A51756572792874686973292E617474722822616374696F6E7479706522293B0D0A09096C416374696F6E5661';
wwv_flow_api.g_varchar2_table(6) := '6C7565203D20617065782E6A51756572792874686973292E617474722822616374696F6E76616C756522293B0D0A0D0A090969662028207053656C6563744D656E754F7074696F6E203D3D2022594553222029207B0D0A20200D0A090909247328207049';
wwv_flow_api.g_varchar2_table(7) := '74656D49642C206C52657475726E496420293B0D0A090909766172206C56616C7565203D20617065782E6A51756572792874686973292E6368696C6472656E28222E6D692D6F7074696F6E2D7465787422292E617474722822632D76616C756522293B0D';
wwv_flow_api.g_varchar2_table(8) := '0A0909096C56616C7565203D2070446973706C6179466F726D61742E7265706C616365282F23444953504C41595F56414C5545232F672C6C56616C7565290D0A090909617065782E6A517565727928222322202B2070446973706C6179426C6F636B4964';
wwv_flow_api.g_varchar2_table(9) := '202B2022202E6D692D6C6162656C22292E68746D6C28206C56616C756520293B200D0A09097D0D0A0D0A0909617065782E6A517565727928222322202B20704D656E75496420292E6869646528293B0D0A0D0A09092F2F617065782E6A51756572792822';
wwv_flow_api.g_varchar2_table(10) := '23526573756C7453657422292E747269676765722822617065787265667265736822293B0D0A2020202020202020200D0A09096576656E742E73746F7050726F7061676174696F6E28293B0D0A0D0A090973776974636820286C416374696F6E54797065';
wwv_flow_api.g_varchar2_table(11) := '29207B0D0A0D0A0909096361736520224E4F414354494F4E223A20627265616B0D0A0909096361736520225245444952454354223A206C6F636174696F6E2E687265663D6C416374696F6E56616C75653B20627265616B0D0A0909096361736520225355';
wwv_flow_api.g_varchar2_table(12) := '424D4954223A20617065782E7375626D6974286C416374696F6E56616C7565293B20627265616B0D0A0D0A09090964656661756C743A0D0A09097D0D0A097D293B0D0A090D0A092F2F20686F766572206D656E75206F7074696F6E20616E696D6174696F';
wwv_flow_api.g_varchar2_table(13) := '6E0D0A09617065782E6A517565727928222322202B20704D656E754964202B2022202E6D692D6D656E752D6F7074696F6E22292E686F766572282066756E6374696F6E2829207B0D0A0D0A0909617065782E6A51756572792874686973292E6368696C64';
wwv_flow_api.g_varchar2_table(14) := '72656E28222E6D692D6F7074696F6E2D69636F6E22292E616464436C61737328704163746976655468656D65436C617373293B0D0A0909617065782E6A51756572792874686973292E6368696C6472656E28222E6D692D6F7074696F6E2D69636F6E2229';
wwv_flow_api.g_varchar2_table(15) := '2E72656D6F7665436C617373282275692D69636F6E2D626C61636B22293B0D0A0D0A0909617065782E6A51756572792874686973292E746F67676C65436C61737328226D692D6F7074696F6E2D686F766572222C74727565293B0D0A0D0A090961706578';
wwv_flow_api.g_varchar2_table(16) := '2E6A51756572792874686973292E6368696C6472656E28222E6D692D7375626D656E7522292E73686F7728293B0D0A0909617065782E6A51756572792874686973292E6368696C6472656E28222E6D692D7375626D656E7522292E706F736974696F6E28';
wwv_flow_api.g_varchar2_table(17) := '7B6D793A226C65667420746F70222C2061743A22726967687420746F70222C206F663A617065782E6A51756572792874686973292C20636F6C6C6973696F6E3A22666C6970227D293B0D0A0D0A097D2C2066756E6374696F6E2829207B0D0A0D0A090961';
wwv_flow_api.g_varchar2_table(18) := '7065782E6A51756572792874686973292E6368696C6472656E28222E6D692D6F7074696F6E2D69636F6E22292E616464436C617373282275692D69636F6E2D626C61636B22293B0D0A0909617065782E6A51756572792874686973292E6368696C647265';
wwv_flow_api.g_varchar2_table(19) := '6E28222E6D692D6F7074696F6E2D69636F6E22292E72656D6F7665436C61737328704163746976655468656D65436C617373293B0D0A0D0A0909617065782E6A51756572792874686973292E746F67676C65436C61737328226D692D6F7074696F6E2D68';
wwv_flow_api.g_varchar2_table(20) := '6F766572222C66616C7365293B0D0A0D0A0909617065782E6A51756572792874686973292E6368696C6472656E28222E6D692D7375626D656E7522292E6869646528293B0D0A097D293B0D0A7D0D0A0D0A66756E6374696F6E206D695F696E6974282070';
wwv_flow_api.g_varchar2_table(21) := '446973706C6179426C6F636B49642C20704D656E7549642C20704974656D49642C207053656C6563744D656E754F7074696F6E2C20704163746976655468656D65436C6173732C2070446973706C6179466F726D61742C2070416A61784964656E746966';
wwv_flow_api.g_varchar2_table(22) := '6965722C2070506172656E744974656D732C20704974656D73746F5375626D69742029207B0D0A0D0A202020202F2F2073686F77206D656E750D0A09617065782E6A517565727928222322202B2070446973706C6179426C6F636B496420292E636C6963';
wwv_flow_api.g_varchar2_table(23) := '6B2866756E6374696F6E286576656E7429207B0D0A0D0A0909617065782E6A517565727928222322202B20704D656E75496420292E73686F7728293B0D0A0909617065782E6A517565727928222322202B20704D656E75496420292E706F736974696F6E';
wwv_flow_api.g_varchar2_table(24) := '287B6D793A2263656E74657220746F70222C2061743A22626F74746F6D222C206F663A222322202B2070446973706C6179426C6F636B49642C20636F6C6C6973696F6E3A22666974227D293B0D0A0D0A09096576656E742E73746F7050726F7061676174';
wwv_flow_api.g_varchar2_table(25) := '696F6E28293B0D0A097D293B0D0A090D0A092F2F72656672657368206D656E750D0A09617065782E6A517565727928222322202B20704974656D496420292E62696E6428226170657872656672657368222C2066756E6374696F6E2829207B0D0A090D0A';
wwv_flow_api.g_varchar2_table(26) := '0909617065782E6A517565727928222322202B20704974656D496420292E747269676765722822617065786265666F72657265667265736822293B0D0A0909617065782E6A517565727928222322202B2070446973706C6179426C6F636B496420292E61';
wwv_flow_api.g_varchar2_table(27) := '7070656E6428273C7370616E20636C6173733D22617065782D6C6F6164696E672D696E64696361746F72223E3C2F7370616E3E27293B0D0A09090D0A0909766172206C4974656D73746F5375626D69743B0D0A090969662028704974656D73746F537562';
wwv_flow_api.g_varchar2_table(28) := '6D697429207B0D0A0909200D0A0909096C4974656D73746F5375626D6974203D2070506172656E744974656D73202B20272C27202B20704974656D73746F5375626D69743B0D0A09097D20656C7365207B0D0A0909096C4974656D73746F5375626D6974';
wwv_flow_api.g_varchar2_table(29) := '203D2070506172656E744974656D733B0D0A09097D0D0A09090D0A0909617065782E7365727665722E706C7567696E282070416A61784964656E7469666965722C207B207830313A20224150455852454652455348222C20706167654974656D733A206C';
wwv_flow_api.g_varchar2_table(30) := '4974656D73746F5375626D6974207D2C207B2064617461547970653A202268746D6C22202C20737563636573733A2066756E6374696F6E282070446174612029207B200D0A0D0A090909766172206C44617461203D20617065782E6A5175657279287044';
wwv_flow_api.g_varchar2_table(31) := '617461292E68746D6C28293B0D0A090909617065782E6A517565727928222322202B20704D656E75496420292E68746D6C286C44617461293B0D0A0909090D0A0909096966202820247628704974656D49642920290D0A09090909617065782E6A517565';
wwv_flow_api.g_varchar2_table(32) := '727928222322202B20704D656E754964202B2022202E6D692D6D656E752D6F7074696F6E22292E65616368282066756E6374696F6E2829207B0D0A09090909090D0A09090909096966202820617065782E6A51756572792874686973292E617474722822';
wwv_flow_api.g_varchar2_table(33) := '72657475726E69642229203D3D20247628704974656D4964292029207B0D0A0909090909090D0A090909090909766172206C56616C7565203D20617065782E6A51756572792874686973292E6368696C6472656E28222E6D692D6F7074696F6E2D746578';
wwv_flow_api.g_varchar2_table(34) := '7422292E617474722822632D76616C756522293B0D0A0909090909096C56616C7565203D2070446973706C6179466F726D61742E7265706C616365282F23444953504C41595F56414C5545232F672C6C56616C7565293B0D0A0909090909090D0A090909';
wwv_flow_api.g_varchar2_table(35) := '09090969662028206C56616C756520213D20617065782E6A517565727928222322202B2070446973706C6179426C6F636B4964202B2022202E6D692D6C6162656C22292E68746D6C28292029200D0A09090909090909617065782E6A5175657279282223';
wwv_flow_api.g_varchar2_table(36) := '22202B2070446973706C6179426C6F636B4964202B2022202E6D692D6C6162656C22292E68746D6C28206C56616C756520293B200D0A09090909097D0D0A090909097D293B0D0A0909090D0A0909096D695F6F7074696F6E5F696E697428207044697370';
wwv_flow_api.g_varchar2_table(37) := '6C6179426C6F636B49642C20704D656E7549642C20704974656D49642C207053656C6563744D656E754F7074696F6E2C20704163746976655468656D65436C6173732C2070446973706C6179466F726D61742C2070416A61784964656E7469666965722C';
wwv_flow_api.g_varchar2_table(38) := '2070506172656E744974656D732C20704974656D73746F5375626D697420293B0D0A0909090D0A090909617065782E6A517565727928222322202B2070446973706C6179426C6F636B4964202B2022202E617065782D6C6F6164696E672D696E64696361';
wwv_flow_api.g_varchar2_table(39) := '746F722220292E72656D6F766528293B0D0A090909617065782E6A517565727928222322202B20704974656D496420292E7472696767657228226170657861667465727265667265736822293B0D0A09097D7D293B0D0A097D293B0D0A090D0A092F2F43';
wwv_flow_api.g_varchar2_table(40) := '6173636164696E67204C4F5620506172656E74204974656D2873290D0A096966202870506172656E744974656D7329207B0D0A09090D0A0909617065782E6A51756572792870506172656E744974656D73292E62696E6428226368616E6765222C206675';
wwv_flow_api.g_varchar2_table(41) := '6E6374696F6E2829207B0D0A09090D0A090909617065782E6A517565727928222322202B20704974656D496420292E747269676765722822617065787265667265736822293B0D0A09097D293B0D0A097D0D0A090D0A094669784F766572666C6F774869';
wwv_flow_api.g_varchar2_table(42) := '6464656E28704974656D4964293B0D0A0D0A092F2F2068696465206C697374206F6E20636C69636B206F7574736964650D0A09617065782E6A517565727928646F63756D656E74292E636C69636B2866756E6374696F6E2829207B0D0A0D0A0909617065';
wwv_flow_api.g_varchar2_table(43) := '782E6A517565727928222322202B20704D656E754964292E6869646528293B0D0A097D293B0D0A200D0A092F2F20686F76657220646973706C617920656C656D656E7420616E696D6174696F6E0D0A09617065782E6A517565727928222322202B207044';
wwv_flow_api.g_varchar2_table(44) := '6973706C6179426C6F636B496420292E686F766572282066756E6374696F6E2829207B0D0A0D0A0909617065782E6A51756572792874686973292E66696E6428222E6D692D69636F6E22292E616464436C61737328704163746976655468656D65436C61';
wwv_flow_api.g_varchar2_table(45) := '7373293B0D0A0909617065782E6A51756572792874686973292E66696E6428222E6D692D69636F6E22292E72656D6F7665436C617373282275692D69636F6E2D626C61636B22293B0D0A0D0A0909617065782E6A51756572792874686973292E66696E64';
wwv_flow_api.g_varchar2_table(46) := '28222E6D692D6C6162656C22292E746F67676C65436C61737328226D692D686F766572222C74727565293B0D0A0909617065782E6A51756572792874686973292E746F67676C65436C61737328226D692D686F766572222C74727565293B0D0A0D0A097D';
wwv_flow_api.g_varchar2_table(47) := '2C2066756E6374696F6E2829207B0D0A0D0A0909617065782E6A51756572792874686973292E66696E6428222E6D692D69636F6E22292E616464436C617373282275692D69636F6E2D626C61636B22293B0D0A0909617065782E6A517565727928746869';
wwv_flow_api.g_varchar2_table(48) := '73292E66696E6428222E6D692D69636F6E22292E72656D6F7665436C61737328704163746976655468656D65436C617373293B0D0A0D0A0909617065782E6A51756572792874686973292E66696E6428222E6D692D6C6162656C22292E746F67676C6543';
wwv_flow_api.g_varchar2_table(49) := '6C61737328226D692D686F766572222C66616C7365293B0D0A0909617065782E6A51756572792874686973292E746F67676C65436C61737328226D692D686F766572222C66616C7365293B0D0A097D293B0D0A090D0A096D695F6F7074696F6E5F696E69';
wwv_flow_api.g_varchar2_table(50) := '74282070446973706C6179426C6F636B49642C20704D656E7549642C20704974656D49642C207053656C6563744D656E754F7074696F6E2C20704163746976655468656D65436C6173732C2070446973706C6179466F726D61742C2070416A6178496465';
wwv_flow_api.g_varchar2_table(51) := '6E7469666965722C2070506172656E744974656D732C20704974656D73746F5375626D697420293B0D0A7D';
null;
 
end;
/

 
begin
 
wwv_flow_api.create_plugin_file (
  p_id => 14783529594776276 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 14105553394102204 + wwv_flow_api.g_id_offset
 ,p_file_name => 'mi.js'
 ,p_mime_type => 'application/javascript'
 ,p_file_content => wwv_flow_api.g_varchar2_table
  );
null;
 
end;
/

commit;
begin
execute immediate 'begin sys.dbms_session.set_nls( param => ''NLS_NUMERIC_CHARACTERS'', value => '''''''' || replace(wwv_flow_api.g_nls_numeric_chars,'''''''','''''''''''') || ''''''''); end;';
end;
/
set verify on
set feedback on
set define on
prompt  ...done
