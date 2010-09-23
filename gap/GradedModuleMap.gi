#############################################################################
##
##  GradedModuleMap.gi               Graded Modules package
##
##  Copyright 2010,      Mohamed Barakat, University of Kaiserslautern
##                       Markus Lange-Hegermann, RWTH Aachen
##
##  Implementation stuff for graded maps ( = graded module homomorphisms ).
##
#############################################################################

####################################
#
# representations:
#
####################################

##  <#GAPDoc Label="IsMapOfGradedModulesRep">
##  <ManSection>
##    <Filt Type="Representation" Arg="phi" Name="IsMapOfFinitelyGeneratedModulesRep"/>
##    <Returns><C>true</C> or <C>false</C></Returns>
##    <Description>
##      The &GAP; representation of maps between graded &homalg; modules. <P/>
##      (It is a representation of the &GAP; categories <C>IsHomalgMap</C>,
##       and <C>IsStaticMorphismOfFinitelyGeneratedObjectsRep</C>.)
##    </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareRepresentation( "IsMapOfGradedModulesRep",
        IsHomalgGradedMap and
        IsStaticMorphismOfFinitelyGeneratedObjectsRep,
        [ "UnderlyingMorphism" ] );

####################################
#
# global variables:
#
####################################

HOMALG_GRADED_MODULES.FunctorOn :=  [ IsHomalgGradedRingOrGradedModuleRep,
				      IsMapOfGradedModulesRep,
				      [ IsComplexOfFinitelyPresentedObjectsRep, IsCocomplexOfFinitelyPresentedObjectsRep ],
				      [ IsChainMapOfFinitelyPresentedObjectsRep, IsCochainMapOfFinitelyPresentedObjectsRep ] ];

####################################
#
# families and types:
#
####################################

# a new family:
BindGlobal( "TheFamilyOfHomalgGradedMaps",
        NewFamily( "TheFamilyOfHomalgGradedMaps" ) );

# four new types:
BindGlobal( "TheTypeHomalgMapOfGradedLeftModules",
        NewType( TheFamilyOfHomalgGradedMaps,
                IsMapOfGradedModulesRep and IsHomalgLeftObjectOrMorphismOfLeftObjects ) );

BindGlobal( "TheTypeHomalgMapOfGradedRightModules",
        NewType( TheFamilyOfHomalgGradedMaps,
                IsMapOfGradedModulesRep and IsHomalgRightObjectOrMorphismOfRightObjects ) );

BindGlobal( "TheTypeHomalgSelfMapOfGradedLeftModules",
        NewType( TheFamilyOfHomalgGradedMaps,
                IsMapOfGradedModulesRep and IsHomalgSelfMap and IsHomalgLeftObjectOrMorphismOfLeftObjects ) );

BindGlobal( "TheTypeHomalgSelfMapOfGradedRightModules",
        NewType( TheFamilyOfHomalgGradedMaps,
                IsMapOfGradedModulesRep and IsHomalgSelfMap and IsHomalgRightObjectOrMorphismOfRightObjects ) );

####################################
#
# methods for operations:
#
####################################

InstallMethod( UnderlyingMorphism,
        "for homalg graded module maps",
        [ IsMapOfGradedModulesRep ],
  function( M )
    
    return M!.UnderlyingMorphism;
    
end );

####################################
#
# constructors
#
####################################

InstallMethod( GradedMap,
        "For homalg matrices",
        [ IsHomalgMatrix, IsString, IsHomalgGradedRingRep ],
  function( A, s, R )
    return GradedMap( A, "free", "free", s, R );
end ); 

InstallMethod( GradedMap,
        "For homalg matrices",
        [ IsHomalgMatrix, IsObject, IsObject ],
  function( A, BB, CC )
    if IsHomalgGradedModule( BB ) then
      return GradedMap( A, BB, CC, HomalgRing( BB ) );
    elif IsHomalgGradedModule( CC ) then
      return GradedMap( A, BB, CC, HomalgRing( CC ) );
    else
      Error( "expected a graded ring or graded Modules in the arguments" );
    fi;
end ); 

InstallMethod( GradedMap,
        "For homalg matrices",
        [ IsHomalgMatrix, IsObject, IsObject, IsHomalgGradedRingRep ],
  function( A, BB, CC, R )
    if ( IsHomalgStaticObject( BB ) and IsHomalgLeftObjectOrMorphismOfLeftObjects( BB ) ) or
      ( IsHomalgStaticObject( CC ) and IsHomalgLeftObjectOrMorphismOfLeftObjects( CC ) ) then
      return GradedMap( A, BB, CC, "left", R );
    else
      return GradedMap( A, BB, CC, "right", R );
    fi;
end ); 

InstallMethod( GradedMap,
        "For homalg matrices",
        [ IsHomalgMatrix, IsObject, IsString ],
  function( A, B, s )
  local left;
    if IsHomalgGradedModule( B ) then
      return GradedMap( A, B, s, HomalgRing( B ) );
    else
      Error( "expected a graded ring or graded Modules in the arguments" );
    fi;
end ); 

InstallMethod( GradedMap,
        "For homalg matrices",
        [ IsHomalgMatrix, IsObject, IsString, IsHomalgGradedRingRep ],
  function( A, B, s, R )
  local left;
    if s = "free" then
      if  IsHomalgGradedModule( B ) then
        left := IsHomalgLeftObjectOrMorphismOfLeftObjects( B );
      elif IsList( B ) and IsHomalgGradedModule( B[1] ) then
        left := IsHomalgLeftObjectOrMorphismOfLeftObjects( B[1] );
      else
        Error( "No information whether to construct a morphism between left modules or a morphism between right modules" );
      fi;
      if left then
        return GradedMap( A, B, "free", "left", R );
      else
        return GradedMap( A, B, "free", "right", R );
      fi;
    else
      return GradedMap( A, B, "free", s, R );
    fi;
end ); 

InstallMethod( GradedMap,
        "for homalg matrices",
        [ IsHomalgMatrix, IsObject, IsObject, IsString ],
  function( matrix, source, target, s)
    if IsHomalgGradedModule( source ) then
      return GradedMap( matrix, source, target, s, HomalgRing( source ) );
    elif IsHomalgGradedModule( target ) then
      return GradedMap( matrix, source, target, s, HomalgRing( target ) );
    elif IsHomalgGradedMatrixRep( matrix) then
      return GradedMap( matrix, source, target, s, HomalgRing( matrix ) );
    else
      Error( "expected a graded ring or graded Modules in the arguments" );
    fi;
end );

InstallMethod( GradedMap,
        "for homalg matrices",
        [ IsHomalgMatrix, IsObject, IsObject, IsHomalgGradedRingRep ],
  function( matrix, source, target, S)
  local left;
    if  IsHomalgModule( source ) then
      left := IsHomalgLeftObjectOrMorphismOfLeftObjects( source );
    elif IsList( source ) and IsHomalgModule( source[1] ) then
      left := IsHomalgLeftObjectOrMorphismOfLeftObjects( source[1] );
    elif IsHomalgModule( target ) then
      left := IsHomalgLeftObjectOrMorphismOfLeftObjects( target );
    elif IsList( target ) and IsHomalgModule( target[1] ) then
      left := IsHomalgLeftObjectOrMorphismOfLeftObjects( target[1] );
    fi;
    if not IsBound( left ) then
      Error( "No information whether to construct a morphism between left modules or a morphism between right modules" );
    fi;
    if left then
      left := "left";
    else
      left := "right";
    fi;
    return GradedMap( matrix, source, target, left, S );
end );

InstallMethod( GradedMap,
        "for homalg matrices",
        [ IsHomalgMatrix, IsObject, IsObject, IsString, IsHomalgGradedRingRep ],
  function( matrix, source, target, s, S )
  local left, nr_gen_s, nr_gen_t, source2, pos_s, degrees_s, target2, pos_t, degrees_t, underlying_morphism, type, morphism;

    #check for information about left or right modules
    if IsStringRep( s ) and Length( s ) > 0 then
      if LowercaseString( s{[1..1]} ) = "r" then
        left := false;  ## we explicitly asked for a morphism of right modules
      else
        left := true;
      fi;
    fi;
    if not IsBound( left ) then
      if  IsHomalgModule( source ) then
        left := IsHomalgLeftObjectOrMorphismOfLeftObjects( source );
      elif IsList( source ) and IsHomalgModule( source[1] ) then
        left := IsHomalgLeftObjectOrMorphismOfLeftObjects( source[1] );
      elif IsHomalgModule( target ) then
        left := IsHomalgLeftObjectOrMorphismOfLeftObjects( target );
      elif IsList( target ) and IsHomalgModule( target[1] ) then
        left := IsHomalgLeftObjectOrMorphismOfLeftObjects( target[1] );
      fi;
    fi;
    if not IsBound( left ) then
      Error( "No information whether to construct a morphism between left modules or a morphism between right modules" );
    fi;
    
    #set nr of generators of both modules
    if left then
      nr_gen_s := NrRows( matrix );
      nr_gen_t := NrColumns( matrix );
    else
      nr_gen_t := NrRows( matrix );
      nr_gen_s := NrColumns( matrix );
    fi;

    #source from input
    if source = "free" then
      if left then
        source2 := FreeLeftModuleWithDegrees( nr_gen_s, S );
      else
        source2 := FreeRightModuleWithDegrees( nr_gen_s, S );
      fi;
    elif ( IsList( source ) and not( IsString( source ) ) ) then
      if Length( source ) = 2 and IsHomalgGradedModule( source[1] ) and IsPosInt( source[2] ) then
        source2 := source[1];
        pos_s := source[2];
        if not IsBound( SetsOfRelations( source2 )!.( pos_s ) ) then
          Error( "the source module does not possess a ", source[2], ". set of relations (this positive number is given as the second entry of the list provided as the second argument)\n" );
        fi;
        degrees_s := DegreesOfGenerators( source2 );
      elif Length( source ) = 2 and IsHomalgModule( source[1] ) and IsPosInt( source[2] ) then
        source2 := GradedModule( source[1], S );
        pos_s := source[2];
        if not IsBound( SetsOfRelations( source2 )!.( pos_s ) ) then
          Error( "the source module does not possess a ", source[2], ". set of relations (this positive number is given as the second entry of the list provided as the second argument)\n" );
        fi;
      elif IsHomogeneousList( source ) and ( source = [] or IsInt( source[1] ) ) then
        degrees_s := source;
        if left then
          source2 := FreeLeftModuleWithDegrees( S, degrees_s );
        else
          source2 := FreeRightModuleWithDegrees( S, degrees_s );
        fi;
      else
      	Error( "Unknow configuration of the second parameter: expected a list of a homalg graded module and an integer (indicating the position of the presentation) or a list of degrees" );
      fi;
    elif IsHomalgGradedModule( source ) then
      source2 := source;
      degrees_s := DegreesOfGenerators( source2 );
    else
      Error( "unknown type of second parameter" );
    fi;
    if not IsBound( pos_s ) then
      pos_s := PositionOfTheDefaultPresentation( source2 );
    fi;
    
    #target from input
    if target = "free" then
      if left then
        target2 := FreeLeftModuleWithDegrees( nr_gen_t, S );
      else
        target2 := FreeRightModuleWithDegrees( nr_gen_t, S );
      fi;
    elif IsList( target ) then
      if Length( target ) = 2 and IsHomalgGradedModule( target[1] ) and IsPosInt( target[2] ) then
        target2 := target[1];
        pos_t := target[2];
        if not IsBound( SetsOfRelations( target2 )!.( pos_t ) ) then
          Error( "the target module does not possess a ", target[2], ". set of relations (this positive number is given as the second entry of the list provided as the third argument)\n" );
        fi;
      elif IsHomogeneousList( target ) and ( target = [] or IsInt( target[1] ) ) then
        degrees_t := target;
        if left then
          target2 := FreeLeftModuleWithDegrees( S, degrees_t );
        else
          target2 := FreeRightModuleWithDegrees( S, degrees_t );
        fi;
      else
        Error( "Unknow configuration of the third parameter: expected a list of a homalg graded module and an integer (indicating the position of the presentation) or a list of degrees" );
      fi;
    elif IsHomalgGradedModule( target ) then
      target2 := target;
    else
      Error( "unknown type of third parameter" );
    fi;
    if not IsBound( pos_t) then
      pos_t := PositionOfTheDefaultPresentation( target2 );
    fi;
    if not IsBound( degrees_t) then
      degrees_t := DegreesOfGenerators( target2 );
    fi;
    
    #construct degrees source according to degrees of target and with the help of generators
    if not IsBound( degrees_s ) then
      if left then
        degrees_s := NonTrivialDegreePerRow( matrix, degrees_t );
      else
        degrees_s := NonTrivialDegreePerColumn( matrix, degrees_t );
      fi;
      source2!.SetOfDegreesOfGenerators!.(pos_s) := degrees_s ;
    fi;
    
    #sanity check on input
    if not( HomalgRing( source2 ) = S and HomalgRing( target2 ) = S ) then
      Error( "Contradictory information about the ring over which to create a graded morphism" );
    fi;

    if left then
      type := TheTypeHomalgMapOfGradedLeftModules;
    else
      type := TheTypeHomalgMapOfGradedRightModules;
    fi;
    
    if IsHomalgGradedMatrixRep( matrix ) then
      underlying_morphism := HomalgMap( UnderlyingNonGradedMatrix( matrix ), UnderlyingModule( source2 ), UnderlyingModule( target2 ) );
    else
      underlying_morphism := HomalgMap( matrix, UnderlyingModule( source2 ), UnderlyingModule( target2 ) );
    fi;
    
    morphism := rec(
      UnderlyingMorphism := underlying_morphism,
      free_resolutions := rec( ),
    );

    ## Objectify:
    ObjectifyWithAttributes(
      morphism, type,
      Source, source2,
      Range, target2
    );

    SetDegreeOfMorphism( morphism, 0 );

    MatchPropertiesAndAttributes( morphism, underlying_morphism, LIGrHOM.match_properties, LIGrHOM.match_attributes );
    
    return morphism;
end ); 

InstallMethod( GradedMap,
        "For homalg morphisms",
        [ IsHomalgMap, IsHomalgGradedRingRep ],
  function( A ,S )
    return GradedMap( A, GradedModule( Source( A ), S ), GradedModule( Range( A ), S ) );
end ); 

InstallMethod( GradedMap,
        "For homalg morphisms",
        [ IsHomalgMap, IsObject, IsHomalgGradedRingRep ],
  function( A, B, S )
    return GradedMap( A, B, GradedModule( Range( A ), S ) );
end ); 

InstallMethod( GradedMap,
        "For homalg morphisms",
        [ IsHomalgMap, IsGradedModuleRep, IsString ],
  function( A, B, s )
    if s = "create" then
      return GradedMap( A, B, HomalgRing( B ) );
    else
      TryNextMethod( );
    fi;
end ); 


# 
InstallMethod( GradedMap,
        "For homalg morphisms",
        [ IsHomalgMap, IsList, IsObject, IsHomalgGradedRingRep ],
  function( A, B, C, S )
    local b;
    
    if IsHomogeneousList( B ) and ( B = [] or IsInt( B[1] ) ) then
      if IsHomalgLeftObjectOrMorphismOfLeftObjects( A ) then
        b := GradedModule( Source( A ), B, S );
      else
        b := GradedModule( Source( A ), B, S );
      fi;
    else
      TryNextMethod();
    fi;
    
    return GradedMap( A, b, C, S );
end );

# 
InstallMethod( GradedMap,
        "For homalg morphisms",
        [ IsHomalgMap, IsObject, IsObject, IsHomalgGradedRingRep ],
  function( A, B, C, S )
  local c, e, deg0, l;
  
    #create target as a free module from input
    if C = "free" then
      if IsHomalgLeftObjectOrMorphismOfLeftObjects( A ) then
        c := FreeLeftModuleWithDegrees( NrColumns( A ), S );
      else
        c := FreeRightModuleWithDegrees( NrRows( A ), S );
      fi;
    #create target from the target of the non-graded map by computing degrees
    elif C = "create" and IsGradedModuleRep( B ) then
      e := DegreesOfEntries( MatrixOfMap( A ) );
      deg0 := DegreeMultivariatePolynomial( Zero( S ) );
      if IsHomalgLeftObjectOrMorphismOfLeftObjects( A ) then 
        l := List( TransposedMat( e ),
                   function( degA_jp ) 
                     local i;
                     i := PositionProperty( degA_jp, a -> not a = deg0 );
                     if i = fail then
                       #this only happens for a zero column in the matrix
                       #then the image of the map projects to zero on that component
                       #we just set this components degree to zero
                       Error("Unexpected zero column in Matrix when computing degrees");
                       return 0;
                     else
                       return DegreesOfGenerators( B )[i] - degA_jp[i];
                     fi;
                   end 
                 );
      else
        l := List( e,
                   function( degA_pj ) 
                     local i;
                     i := PositionProperty( degA_pj, a -> not a = deg0 );
                     if i = fail then
                       #this only happens for a zero row in the matrix
                       #then the image of the map projects to zero on that component
                       #we just set this components degree to zero
                       Error("Unexpected zero row in Matrix when computing degrees");
                       return 0;
                     else
                       return DegreesOfGenerators( B )[i] - degA_pj[i];
                     fi;
                   end 
                 );
      fi;
      if IsHomalgSelfMap( A ) and l = DegreesOfGenerators( B ) then
        c := B;
      else
        c := GradedModule( Range( A ), l, S );
      fi;
    #create target from the target of the non-graded map by given degrees
    elif IsHomogeneousList( C ) and ( C = [] or IsInt( C[1] ) ) then
      if IsHomalgLeftObjectOrMorphismOfLeftObjects( A ) then
        c := GradedModule( Range( A ), C, S );
      else
        c := GradedModule( Range( A ), C, S );
      fi;
    elif IsHomalgGradedModule( C ) then
      c := C;
    else
      Error( "unknown type of third parameter" );
    fi;
  
    return GradedMap( A, B, c );
end );

InstallMethod( GradedMap,
        "For homalg morphisms",
        [ IsHomalgMap, IsObject, IsGradedModuleRep ],
  function( A, BB, CC )
  local S, b, degree;
    
    S := HomalgRing( CC );
    
    #target from input
    if BB = "free" then
      if IsHomalgLeftObjectOrMorphismOfLeftObjects( A ) then
        b := FreeLeftModuleWithDegrees( S, NonTrivialDegreePerRow( MatrixOfMap( A ), DegreesOfGenerators( CC ) ) );
      else
        b := FreeRightModuleWithDegrees( S, NonTrivialDegreePerColumn( MatrixOfMap( A ), DegreesOfGenerators( CC ) ) );
      fi;
    elif BB = "create" then
      if IsHomalgLeftObjectOrMorphismOfLeftObjects( A ) then
        degree := NonTrivialDegreePerRow( MatrixOfMap( A ), DegreesOfGenerators( CC ) );
      else
        degree := NonTrivialDegreePerColumn( MatrixOfMap( A ), DegreesOfGenerators( CC ) );
      fi;
      if IsHomalgSelfMap( A ) and degree = DegreesOfGenerators( CC ) then
        b :=  CC;
      else
        b := GradedModule( Source( A ), degree, S );
      fi;
    elif IsHomogeneousList( BB ) and ( BB = [] or IsInt( BB[1] ) ) then
      b := GradedModule( Source( A ), BB, S );
    elif IsHomalgGradedModule( BB ) then
      b := BB;
    elif IsHomalgModule( BB ) and IsIdenticalObj( BB, Source( A ) ) then
      if IsHomalgLeftObjectOrMorphismOfLeftObjects( A ) then
        b := GradedModule( BB, NonTrivialDegreePerRow( MatrixOfMap( A ), DegreesOfGenerators( CC ) ) );
      else
        b := GradedModule( BB, NonTrivialDegreePerColumn( MatrixOfMap( A ), DegreesOfGenerators( CC ) ) );
      fi;
    else
      Error( "unknown type of second parameter" );
    fi;
  
    return GradedMap( A, b, CC );
end ); 

InstallMethod( GradedMap,
        "For homalg morphisms",
        [ IsHomalgMap, IsGradedModuleRep, IsGradedModuleRep ],
  function( A, B, C )
  local type, morphism;

    if IsMapOfGradedModulesRep( A ) then
      return A;
    fi;

    if not IsIdenticalObj( UnderlyingModule( B ), Source( A ) ) then
      Error( "the underlying non-graded modules for the source and second parameter do not match" );
    fi;
    if not IsIdenticalObj( UnderlyingModule( C ), Range( A ) ) then
      Error( "the underlying non-graded modules for the source and second parameter do not match" );
    fi;

    if IsHomalgLeftObjectOrMorphismOfLeftObjects( A ) then
      type := TheTypeHomalgMapOfGradedLeftModules;
    else
      type := TheTypeHomalgMapOfGradedRightModules;
    fi;
    
    morphism := rec(
      UnderlyingMorphism := A,
      free_resolutions := rec( ),
    );

    ## Objectify:
    ObjectifyWithAttributes(
      morphism, type,
      Source, B,
      Range, C );

    SetDegreeOfMorphism( morphism, 0 );

    MatchPropertiesAndAttributes( morphism, A, LIGrHOM.match_properties, LIGrHOM.match_attributes );
    
    return morphism;
end );

InstallMethod( GradedZeroMap,
        "For graded modules",
        [ IsGradedModuleRep, IsGradedModuleRep ],
  function( M, N )
  
    return GradedMap( HomalgZeroMap( UnderlyingModule( M ), UnderlyingModule( N ) ), M, N );
  
end );

####################################
#
# View, Print, and Display methods:
#
####################################

InstallMethod( ViewObj,
        "for homalg graded module maps",
        [ IsMapOfGradedModulesRep ],
        
  function( o )
    
    Print( "<A homalg graded module map>" );
    
end );

##
InstallMethod( Display,
        "for homalg graded module maps",
        [ IsMapOfGradedModulesRep ], ## since we don't use the filter IsHomalgLeftObjectOrMorphismOfLeftObjects we need to set the ranks high
        
  function( o )
    
    Print( "<A map between homalg graded modules building on the underlying homalg map\n" );
    
    Display( UnderlyingMorphism( o ) );
    
    Print( "\n>\n" );
    
end );