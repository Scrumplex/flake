# Defined via `source`
function kdesrc-rebuild --description 'Rebuild component of kdesrc-build without dependencies and updating source'
  kdesrc-build --no-src --no-include-dependencies $argv; 
end
