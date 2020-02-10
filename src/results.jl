"""
    JuMP.termination_status(model::InfiniteModel)

Return the reason why the solver stopped (i.e., the MathOptInterface model
attribute `TerminationStatus`).

**Example**
```julia-repl
julia> termination_status(model)
LOCALLY_SOLVED::TerminationStatusCode = 4
```
"""
function JuMP.termination_status(model::InfiniteModel)
    return JuMP.termination_status(optimizer_model(model))
end

"""
    JuMP.raw_status(model::InfiniteModel)

Return the reason why the solver stopped in its own words (i.e., the
MathOptInterface model attribute `RawStatusString`).

**Example**
```julia-repl
julia> raw_status(model) # Ipopt
"Solve_Succeeded"
```
"""
function JuMP.raw_status(model::InfiniteModel)
    return JuMP.raw_status(optimizer_model(model))
end

"""
     JuMP.primal_status(model::InfiniteModel)

Return the status of the most recent primal solution of the solver (i.e., the
MathOptInterface model attribute `PrimalStatus`).

**Example**
```julia-repl
julia> primal_status(model)
FEASIBLE_POINT::ResultStatusCode = 1
```
"""
function  JuMP.primal_status(model::InfiniteModel)
    return JuMP.primal_status(optimizer_model(model))
end

"""
    JuMP.dual_status(model::InfiniteModel)

Return the status of the most recent dual solution of the solver (i.e., the
MathOptInterface model attribute `DualStatus`).

**Example**
```julia-repl
julia> dual_status(model)
FEASIBLE_POINT::ResultStatusCode = 1
```
"""
function JuMP.dual_status(model::InfiniteModel)
    return JuMP.dual_status(optimizer_model(model))
end

"""
    JuMP.solve_time(model::InfiniteModel)

If available, returns the solve time (in seconds) reported by the solver.
Returns "ArgumentError: ModelLike of type `Solver.Optimizer` does not support accessing
the attribute MathOptInterface.SolveTime()" if the attribute is
not implemented.

**Example**
```julia-repl
julia> solve_time(model)
0.004999876022338867
```
"""
function JuMP.solve_time(model::InfiniteModel)
    return JuMP.solve_time(optimizer_model(model))
end

"""
    JuMP.has_values(model::InfiniteModel)

Return `true` if the solver has a primal solution available to query, otherwise
return `false`.

**Example**
```julia-repl
julia> has_values(model)
true
```
"""
JuMP.has_values(model::InfiniteModel) = JuMP.primal_status(model) != MOI.NO_SOLUTION

"""
    JuMP.has_duals(model::InfiniteModel)

Return `true` if the solver has a dual solution available to query, otherwise
return `false`.

**Example**
```julia-repl
julia> has_duals(model)
true
```
"""
JuMP.has_duals(model::InfiniteModel) = JuMP.dual_status(model) != MOI.NO_SOLUTION

"""
    JuMP.objective_bound(model::InfiniteModel)::Float64

Return the best known bound on the optimal objective value after a call to
`optimize!(model)`.

**Example**
```julia-repl
julia> objective_bound(model)
42.0
```
"""
function JuMP.objective_bound(model::InfiniteModel)::Float64
    return JuMP.objective_bound(optimizer_model(model))
end

"""
    JuMP.objective_value(model::InfiniteModel)::Float64

Return the objective value after a call to `optimize!(model)`.

**Example**
```julia-repl
julia> objective_value(model)
42.0
```
"""
function JuMP.objective_value(model::InfiniteModel)::Float64
    return JuMP.objective_value(optimizer_model(model))
end

"""
    map_value(vref::GeneralVariableRef, key)

Map the value of `vref` to its counterpart in the optimizer model type is
distininguished by its extension key `key` as type `Val{ext_key_name}`.
"""
function map_value end

"""
    JuMP.value(vref::GeneralVariableRef)

Get the value of this variable in the result returned by a solver. Use
[`JuMP.has_values`](@ref JuMP.has_values(::InfiniteModel)) to check if a result
exists before asking for values.

**Example**
```julia-repl
julia> value(z)
42.0
```
"""
function JuMP.value(vref::GeneralVariableRef)
    return map_value(vref, Val(optimizer_model_key(JuMP.owner_model(vref))))
end

"""
    JuMP.value(cref::GeneralConstraintRef)

Get the value of this constraint in the result returned by a solver. Use
[`JuMP.has_values`](@ref JuMP.has_values(::InfiniteModel)) to check if a result
exists before asking for values.
This returns the primal value of the constraint function.

**Example**
```julia-repl
julia> value(c1)
4-element Array{Float64,1}:
 -0.0
 20.9
 20.9
 20.9
```
"""
function JuMP.value(cref::GeneralConstraintRef)
    return map_value(cref, Val(optimizer_model_key(JuMP.owner_model(cref))))
end

"""
    map_optimizer_index(ref, key)

Map the optimizer index of `ref` to its counterpart in the optimizer model
type distininguished by its extension key `key` as type `Val{ext_key_name}`.
Here `ref` need refer to methods for both variable references and constraint
references.
"""
function map_optimizer_index end

"""
    JuMP.optimizer_index(vref::GeneralVariableRef)

Return the index of the variables that corresponds to `vref` in the optimizer model.
It throws [`JuMP.NoOptimizer`](@ref) if no optimizer is set and throws an
`ErrorException` if the optimizer is set but is not attached.

**Example**
```julia-repl
julia> optimizer_index(x)
4-element Array{MathOptInterface.VariableIndex,1}:
 MathOptInterface.VariableIndex(2)
 MathOptInterface.VariableIndex(3)
 MathOptInterface.VariableIndex(4)
 MathOptInterface.VariableIndex(5)
```
"""
function JuMP.optimizer_index(vref::GeneralVariableRef)
    return map_optimizer_index(vref,
                               Val(optimizer_model_key(JuMP.owner_model(vref))))
end

"""
    JuMP.optimizer_index(cref::GeneralConstraintRef)

Return the index of the constraints that corresponds to `cref` in the optimizer model.
It throws [`JuMP.NoOptimizer`](@ref) if no optimizer is set and throws an
`ErrorException` if the optimizer is set but is not attached.

**Example**
```julia-repl
julia> optimizer_index(c1)
4-element Array{MathOptInterface.ConstraintIndex{MathOptInterface.ScalarAffineFunction{Float64},MathOptInterface.GreaterThan{Float64}},1}:
 MathOptInterface.ConstraintIndex{MathOptInterface.ScalarAffineFunction{Float64},MathOptInterface.GreaterThan{Float64}}(1)
 MathOptInterface.ConstraintIndex{MathOptInterface.ScalarAffineFunction{Float64},MathOptInterface.GreaterThan{Float64}}(2)
 MathOptInterface.ConstraintIndex{MathOptInterface.ScalarAffineFunction{Float64},MathOptInterface.GreaterThan{Float64}}(3)
 MathOptInterface.ConstraintIndex{MathOptInterface.ScalarAffineFunction{Float64},MathOptInterface.GreaterThan{Float64}}(4)
```
"""
function JuMP.optimizer_index(cref::GeneralConstraintRef)
    return map_optimizer_index(cref,
                               Val(optimizer_model_key(JuMP.owner_model(cref))))
end

"""
    map_dual(cref::GeneralConstraintRef, key)

Map the dual of `cref` to its counterpart in the optimizer model
type distininguished by its extension key `key` as type `Val{ext_key_name}`.
"""
function map_dual end

"""
    JuMP.dual(cref::GeneralConstraintRef)

Get the dual value of this constraint in the result returned by a solver.
Use `has_dual` to check if a result exists before asking for values.
See also [`JuMP.shadow_price`](@ref JuMP.shadow_price(::GeneralConstraintRef)).

**Example**
```julia-repl
julia> dual(c1)
4-element Array{Float64,1}:
 -42.0
 -42.0
 32.3
 0.0
```
"""
function JuMP.dual(cref::GeneralConstraintRef)
    return map_dual(cref, Val(optimizer_model_key(JuMP.owner_model(cref))))
end

# Error redriect dor variable call
function JuMP.dual(vref::GeneralVariableRef)
    error("To query the dual variables associated with a variable bound, first " *
          "obtain a constraint reference using one of `UpperBoundRef`, `LowerBoundRef`, " *
          "or `FixRef`, and then call `dual` on the returned constraint reference.\nFor " *
          "example, if `x <= 1`, instead of `dual(x)`, call `dual(UpperBoundRef(x))`.")
end

"""
    map_shadow_price(cref::GeneralConstraintRef, key)

Map the shadow price of `cref` to its counterpart in the optimizer model
type distininguished by its extension key `key` as type `Val{ext_key_name}`.
"""
function map_shadow_price end

"""
    JuMP.shadow_price(cref::GeneralConstraintRef)

The change in the objective from an infinitesimal relaxation of the constraint.
This value is computed from [`JuMP.dual`](@ref JuMP.dual(::GeneralConstraintRef))
and can be queried only when
`has_duals` is `true` and the objective sense is `MIN_SENSE` or `MAX_SENSE`
(not `FEASIBILITY_SENSE`). For linear constraints, the shadow prices differ at
most in sign from the `dual` value depending on the objective sense.

**Example**
```julia-repl
julia> shadow_price(c1)
4-element Array{Float64,1}:
 42.0
 42.0
 -32.3
 -0.0
```
"""
function JuMP.shadow_price(cref::GeneralConstraintRef)
    return map_shadow_price(cref,
                            Val(optimizer_model_key(JuMP.owner_model(cref))))
end
