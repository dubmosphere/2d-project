using Godot;
using System;

public partial class Player : CharacterBody2D
{
	public const float SPEED = 300.0f;
	public const float JUMP_VELOCITY = -610.0f;

	protected int jumpCount = 0;
	protected AnimationTree animationTree;
	protected AnimationNodeStateMachinePlayback animationStateMachine;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		animationTree = GetNode<AnimationTree>("Sprite2D/PlayerAnimationTree");
		animationStateMachine = (AnimationNodeStateMachinePlayback)animationTree.Get("parameters/playback");
		InitializeAnimations();
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		if(Input.IsActionJustPressed("quit")) {
			GetTree().Quit();
		} else if(Input.IsActionJustPressed("pause")) {
			GetTree().Paused = true;
		}
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _PhysicsProcess(double delta)
	{
		HandleMovement(delta);
		HandleAnimations();
		MoveAndSlide();
	}

	public void InitializeAnimations()
	{
		animationTree.Set("parameters/idle/blend_position", 1);
		animationTree.Set("parameters/walk/blend_position", 1);
		animationTree.Set("parameters/jump_up/blend_position", 1);
		animationTree.Set("parameters/jump_down/blend_position", 1);
		animationTree.Get("parameters/playback");
		animationStateMachine.Travel("idle");
	}

	public void HandleMovement(double delta)
    {
		Vector2 velocity = Velocity;
        if (!IsOnFloor())
        {
			velocity.X += GetGravity().Y * (float)delta;
			velocity.Y += GetGravity().Y * (float)delta;
        }

		if(Input.IsActionJustPressed("jump") && IsOnFloor()) {
			velocity.Y = JUMP_VELOCITY;
			jumpCount++;
		} else if(Input.IsActionJustPressed("jump") && jumpCount > 0 && jumpCount < 2 && !IsOnFloor()) {
			velocity.Y = JUMP_VELOCITY;
			jumpCount++;
		} else if(jumpCount > 0 && IsOnFloor()) {
			jumpCount = 0;
		}

		float direction = Input.GetAxis("left", "right");
		if(!float.IsNaN(direction)) {
			velocity.X = direction * SPEED;
		} else {
			velocity.X = Mathf.MoveToward(velocity.X, 0, SPEED);
		}
		
		Velocity = velocity;
    }

    public void HandleAnimations()
	{
		if(!IsOnFloor()) {
			if(Velocity.Y < 0) {
				animationStateMachine.Travel("jump_up");
			} else {
				animationStateMachine.Travel("jump_down");
			}
		} else {
			if(Velocity.X == 0) {
				animationStateMachine.Travel("idle");
			} else {
				animationStateMachine.Travel("walk");
			}
		}

		UpdateBlendPositions();
	}

	public void UpdateBlendPositions()
	{
		if(Velocity.X != 0) {
			animationTree.Set("parameters/idle/blend_position", Velocity.X);
			animationTree.Set("parameters/walk/blend_position", Velocity.X);
			animationTree.Set("parameters/jump_up/blend_position", Velocity.X);
			animationTree.Set("parameters/jump_down/blend_position", Velocity.X);
		}
	}
}
