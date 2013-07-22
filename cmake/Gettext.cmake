find_package(Gettext)

function(gettext po_dir package_name install_dest)
   set(mo_files)
   
   file(GLOB po_files ${po_dir}/*.po)
   foreach(po_file ${po_files})
      get_filename_component(lang ${po_file} NAME_WE)
      set(mo_file ${CMAKE_CURRENT_BINARY_DIR}/${lang}.mo)
      add_custom_command(OUTPUT ${mo_file} COMMAND ${GETTEXT_MSGFMT_EXECUTABLE} -o ${mo_file} ${po_file} DEPENDS ${po_file})

      if(install_dest)
         install(FILES ${mo_file} DESTINATION ${install_dest}/${lang}/LC_MESSAGES RENAME ${package_name}.mo)
      else()
         install(FILES ${mo_file} DESTINATION share/locale/${lang}/LC_MESSAGES RENAME ${package_name}.mo)
      endif()
      set(mo_files ${mo_files} ${mo_file})
   endforeach()
   set(translations-target "${package_name}-translations")
   add_custom_target(${translations-target} ALL DEPENDS ${mo_files})
endfunction()