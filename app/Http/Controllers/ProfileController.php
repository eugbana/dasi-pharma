<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rules\Password;
use Inertia\Inertia;
use Inertia\Response;

class ProfileController extends Controller
{
    /**
     * Display the user's profile form.
     */
    public function edit(Request $request): Response
    {
        $user = $request->user()->load(['role', 'branch']);

        // Determine if user can set an authorization code based on their role
        $authorizableRoles = ['Super Admin', 'Pharmacist', 'Manager', 'Admin'];
        $canSetAuthCode = $user->role && in_array($user->role->name, $authorizableRoles);

        return Inertia::render('Profile/Edit', [
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'role' => $user->role,
                'branch' => $user->branch,
                'can_authorize' => $user->can_authorize,
                'can_set_auth_code' => $canSetAuthCode,
                'has_authorization_code' => !empty($user->authorization_code),
            ],
        ]);
    }

    /**
     * Update the user's profile information.
     */
    public function update(Request $request)
    {
        $user = $request->user();

        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|max:255|unique:users,email,' . $user->id,
            'current_password' => 'nullable|required_with:password|string',
            'password' => ['nullable', 'confirmed', Password::min(8)],
        ]);

        // Verify current password if changing password
        if (!empty($validated['password'])) {
            if (!Hash::check($validated['current_password'], $user->password)) {
                return back()->withErrors(['current_password' => 'The current password is incorrect.']);
            }
            $validated['password'] = Hash::make($validated['password']);
        } else {
            unset($validated['password']);
        }

        unset($validated['current_password']);

        $user->update($validated);

        return back()->with('success', 'Profile updated successfully.');
    }

    /**
     * Update the user's authorization code.
     */
    public function updateAuthorizationCode(Request $request)
    {
        $user = $request->user()->load('role');

        // Only allow users with authorizable roles
        $authorizableRoles = ['Super Admin', 'Pharmacist', 'Manager', 'Admin'];
        $canSetAuthCode = $user->role && in_array($user->role->name, $authorizableRoles);

        if (!$canSetAuthCode) {
            return response()->json([
                'success' => false,
                'message' => 'You do not have permission to set an authorization code.',
            ], 403);
        }

        $validated = $request->validate([
            'authorization_code' => ['required', 'string', 'size:6', 'regex:/^[0-9]{6}$/'],
            'current_password' => 'required|string',
        ]);

        // Verify current password for security
        if (!Hash::check($validated['current_password'], $user->password)) {
            return response()->json([
                'success' => false,
                'message' => 'The current password is incorrect.',
            ], 401);
        }

        // Set the authorization code and enable can_authorize flag
        $user->update([
            'authorization_code' => $validated['authorization_code'],
            'can_authorize' => true,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Authorization code updated successfully.',
        ]);
    }
}

