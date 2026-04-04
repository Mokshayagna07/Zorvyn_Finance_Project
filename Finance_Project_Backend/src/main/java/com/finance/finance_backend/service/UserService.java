package com.finance.finance_backend.service;

import com.finance.finance_backend.entity.Role;
import com.finance.finance_backend.entity.User;
import com.finance.finance_backend.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class UserService {
    private final UserRepository userRepository;

    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    public User getUserById(Long id) {
        return userRepository.findById(id).orElseThrow(() -> new RuntimeException("User not found"));
    }

    public void updateUserRole(Long id, Role newRole) {
        User user = getUserById(id);
        user.setRole(newRole);
        userRepository.save(user);
    }
}
