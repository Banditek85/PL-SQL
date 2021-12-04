CREATE OR REPLACE PACKAGE PLUGIN_JET
AS    
    FUNCTION render (
      p_region              IN apex_plugin.t_region,
      p_plugin              IN apex_plugin.t_plugin,
      p_is_printer_friendly IN BOOLEAN ) 
    RETURN apex_plugin.t_region_render_result;
END;