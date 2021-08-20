CREATE OR REPLACE PACKAGE BODY STARTER
AS
FUNCTION render (
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

        RETURN v_result;
    END render;

    FUNCTION ajax (
        p_region in apex_plugin.t_region,
        p_plugin in apex_plugin.t_plugin )
    RETURN apex_plugin.t_region_ajax_result
    AS
        v_result apex_plugin.t_region_ajax_result;
    BEGIN
        RETURN v_result;
    END ajax;
END;
