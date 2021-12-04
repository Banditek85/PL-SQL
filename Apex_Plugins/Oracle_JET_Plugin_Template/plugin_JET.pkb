CREATE OR REPLACE PACKAGE BODY PLUGIN_JET
AS
    FUNCTION render (
            p_region              IN apex_plugin.t_region,
            p_plugin              IN apex_plugin.t_plugin,
            p_is_printer_friendly IN BOOLEAN )
            RETURN apex_plugin.t_region_render_result
        AS
            v_result apex_plugin.t_region_render_result;
        BEGIN

            htp.p('<div id="explorer"><b>Hello world!</b></div>');
            
            apex_javascript.add_library(
            p_name      => 'main',
            p_directory => p_plugin.file_prefix,
            p_version   => null);

            apex_javascript.add_onload_code(
                  p_code => 'baz();'
            );

            RETURN v_result;
    END render;
END;