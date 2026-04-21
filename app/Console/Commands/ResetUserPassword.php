<?php

namespace App\Console\Commands;

use App\Models\User;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class ResetUserPassword extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'user:reset-password 
                            {email? : The email address of the user}
                            {--password= : The new password (will prompt if not provided)}
                            {--all : Reset all user passwords to "password"}';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Reset a user password with proper bcrypt hashing';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        // Check if we're resetting all users
        if ($this->option('all')) {
            return $this->resetAllPasswords();
        }

        // Get email from argument or ask for it
        $email = $this->argument('email') ?: $this->ask('Enter the user email address');

        // Validate email
        $validator = Validator::make(['email' => $email], [
            'email' => 'required|email',
        ]);

        if ($validator->fails()) {
            $this->error('Invalid email address format.');
            return 1;
        }

        // Find the user
        $user = User::where('email', $email)->first();

        if (!$user) {
            $this->error("No user found with email: {$email}");
            return 1;
        }

        // Get password from option or ask for it
        $password = $this->option('password') ?: $this->secret('Enter new password (min 8 characters)');

        // Validate password length
        if (strlen($password) < 8) {
            $this->error('Password must be at least 8 characters long.');
            return 1;
        }

        // Hash and update the password
        $user->password = Hash::make($password);
        $user->save();

        $this->info("✓ Password successfully updated for: {$user->email}");
        $this->info("  User: {$user->name}");
        $this->info("  Role: {$user->role->name}");
        
        return 0;
    }

    /**
     * Reset all user passwords to "password"
     */
    protected function resetAllPasswords()
    {
        if (!$this->confirm('Are you sure you want to reset ALL user passwords to "password"?', false)) {
            $this->info('Operation cancelled.');
            return 0;
        }

        $users = User::all();
        $hashedPassword = Hash::make('password');
        
        $count = 0;
        foreach ($users as $user) {
            $user->password = $hashedPassword;
            $user->save();
            $count++;
            $this->line("✓ Reset password for: {$user->email}");
        }

        $this->info("\n✓ Successfully reset passwords for {$count} users to 'password'");
        
        return 0;
    }
}
