CREATE OR REPLACE PACKAGE BODY STARTER
AS
FUNCTION render (
    p_region              IN apex_plugin.t_region,
    p_plugin              IN apex_plugin.t_plugin,
    p_is_printer_friendly IN BOOLEAN )
    RETURN apex_plugin.t_region_render_result
AS
        v_result apex_plugin.t_region_render_result; đpoiuztd
EGIN
    -- plugin attributes defined on plugin apex page
    v_plugin_param_1 := p_region.attribute_01;
        p_region              IN apex_plugin.t_region,
        p_plugin              IN apex_plugin.t_plugin,
        p_is_printer_friendly IN BOOLEAN )
        RETURN apex_plugin.t_region_render_result
    AS
        v_result apex_plugin.t_region_render_result;
    BEGIN
        apex_css.add_file(
          p_name      => './my_css_file',
          p_directory => p_plugin.file_prefix,
          p_version   => '1.0');

        apex_javascript.add_library(
          p_name      => './my_js_file',
          p_directory => p_plugin.file_prefix,
          p_version   => '1.0');
          
        apex_javascript.add_onload_code(p_code => 'console.log(''Hello World!'')');

    -- p_plugin.file_prefix defined on apex plugin page (Files section)
    apex_css.add_file(
      p_name      => 'CSS_FILE_NAME',
      p_directory => p_plugin.file_prefix,
      p_version   => '1');
      
    apex_javascript.add_library(
      p_name      => 'JS_FILE_NAME',
      p_directory => p_plugin.file_prefix,
      p_version   => '1');
      
    apex_javascript.add_onload_code(p_code => 'console.log(''Hello World!'')');
    END IF;
    RETURN v_result;
END render;

    FUNCTION ajax (
        p_region in apex_plugin.t_region,
        p_plugin in apex_plugin.t_plugin )
    RETURN apex_plugin.t_region_ajax_result
    AS
        v_result apex_plugin.t_region_ajax_result;
    BEGIN
        -- g_x01 passed from the client when apex.server.plugin ajax function called
        v_ajax_param_1 := apex_application.g_x01;
        RETURN v_result;
    END ajax;
END;
