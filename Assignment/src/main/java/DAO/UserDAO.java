package DAO;

import Entity.User;
import java.util.List;

public interface UserDAO {
    boolean insert(User user);

    User login(String email, String password);

    boolean existsByEmail(String email);

    List<User> findAll();

    User findById(String id);

    boolean update(User user);

    boolean delete(String id);
    
    boolean updatePassword(String userId, String newPassword);
    
    List<User> getAllUsers();
}
