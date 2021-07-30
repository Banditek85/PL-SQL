CREATE OR REPLACE PACKAGE STARTER
AS    
    FUNCTION render (
      p_region              IN apex_plugin.t_region,
      p_plugin              IN apex_plugin.t_plugin,
      p_is_printer_friendly IN BOOLEAN ) 
    RETURN apex_plugin.t_region_render_result;

    FUNCTION ajax (
      p_region IN apex_plugin.t_region,
      p_plugin IN apex_plugin.t_plugin ) 
    RETURN apex_plugin.t_region_ajax_result;
END;