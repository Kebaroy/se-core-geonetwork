package org.fao.geonet.kernel.security.shibboleth;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import org.fao.geonet.AbstractCoreIntegrationTest;
import org.fao.geonet.domain.Group;
import org.fao.geonet.domain.Profile;
import org.fao.geonet.domain.User;
import org.fao.geonet.domain.UserGroup;
import org.fao.geonet.repository.GroupRepository;
import org.fao.geonet.repository.UserGroupRepository;
import org.fao.geonet.repository.UserRepository;
import org.fao.geonet.repository.specification.UserGroupSpecs;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.jpa.domain.Specifications;

/**
 * Tests for the ShibbolethUserUtils class.
 * 
 * @author Conny Nilimaa
 */
public class ShibbolethUserUtilsTest  extends AbstractCoreIntegrationTest{

    @Autowired
    private UserRepository _userRepo;
    
    @Autowired
    private UserGroupRepository _userGroupRepo;
    
    @Autowired
    private GroupRepository _groupRepo;

    /**
     * Test of the findOrCreateGroup method.
     */
    @Test
    public void testFindOrCreateGroup(){
        
        long initialGroupCount = _groupRepo.count();
        
        Group g1 = ShibbolethUserUtils.findOrCreateGroup("group1", _groupRepo);
        ShibbolethUserUtils.findOrCreateGroup("group2", _groupRepo);
        Group g3 = ShibbolethUserUtils.findOrCreateGroup("", _groupRepo);
        Group g4 = ShibbolethUserUtils.findOrCreateGroup(null, _groupRepo);
        Group g1_2 = ShibbolethUserUtils.findOrCreateGroup("group1", _groupRepo);
        
        assertEquals(initialGroupCount+2, _groupRepo.count());        
        assertEquals(g1, g1_2); 
        assertNull(g3);
        assertNull(g4);
    }
    
    /**
     * Test of the addUserToGroup method.
     */
    @Test
    public void testAddUserToGroup(){
                
        long initialUserGroupCount = _userGroupRepo.count();
        
        User user = mockUser();        
        _userRepo.saveAndFlush(user);
                
        Group group = ShibbolethUserUtils.findOrCreateGroup("group1", _groupRepo);
        
        Specifications<UserGroup> spec = Specifications.where(UserGroupSpecs.hasUserId(user.getId()));
        
        List<UserGroup> findAll = _userGroupRepo.findAll(spec);        
        assertEquals(0, findAll.size());
        
        boolean res = isUserInGroup(user, "group1", _groupRepo, _userGroupRepo);
        assertFalse(res);  
        
        ShibbolethUserUtils.addUserToGroup(user, group, _userGroupRepo);
        
        findAll = _userGroupRepo.findAll(spec);        
        assertEquals(1, findAll.size());
        res = isUserInGroup(user, "group1", _groupRepo, _userGroupRepo);
        assertTrue(res);
        
        // try to add again, should not affect anything
        ShibbolethUserUtils.addUserToGroup(user, group, _userGroupRepo);
        ShibbolethUserUtils.addUserToGroup(user, group, _userGroupRepo);
        
        findAll = _userGroupRepo.findAll(spec);        
        assertEquals(1, findAll.size());
        res = isUserInGroup(user, "group1", _groupRepo, _userGroupRepo);
        assertTrue(res);
        
        assertEquals(initialUserGroupCount+1, _userGroupRepo.count());
        
        spec = Specifications.where(UserGroupSpecs.hasGroupId(group.getId()));
        
        findAll = _userGroupRepo.findAll(spec);        
        assertEquals(1, findAll.size());
    }
    
    /**
     * Test of helper method isUserInGroup.
     */
    @Test
    public void testIsUserInGroup(){
        User user = mockUser();        
        _userRepo.saveAndFlush(user);
        
        boolean res = isUserInGroup(user, "aGroup", _groupRepo, _userGroupRepo);
        assertFalse(res);
        
        Group g = new Group().setName("aGroup");
        g = _groupRepo.saveAndFlush(g);
        
        UserGroup userGroup = new UserGroup().setGroup(g).setUser(user).setProfile(user.getProfile());
        _userGroupRepo.saveAndFlush(userGroup); 
      
        res = isUserInGroup(user, "aGroup", _groupRepo, _userGroupRepo);
        assertTrue(res);              
    }
    
    /**
     * Test updating the group upon user setup.
     * @throws Exception
     */
    @Test
    public void testUpdateGroup() throws Exception{
        long initialGroupCount = _groupRepo.count();
        long initialUserGroupCount = _userGroupRepo.count();
        
        HttpServletRequest request = mockRequest();
        ShibbolethUserConfiguration config = mockConfig();
        
        ShibbolethUserUtils suu = new ShibbolethUserUtils();
        
        // this will create user and add it to myGroup
        User user1 = (User) suu.setupUser(request, config);
        
        assertEquals(initialGroupCount+1, _groupRepo.count());
        assertEquals(initialUserGroupCount+1, _userGroupRepo.count());
        
        // we don't allow update of group so this will not affect anything
        when(request.getHeader("group")).thenReturn("otherGroup");
        User user2 = (User) suu.setupUser(request, config);
        
        assertEquals(initialGroupCount+1, _groupRepo.count());
        assertEquals(initialUserGroupCount+1, _userGroupRepo.count());        
        assertEquals(user1.getId(), user2.getId());
        
        Specifications<UserGroup> spec = Specifications.where(UserGroupSpecs.hasUserId(user2.getId()));
        
        List<UserGroup> user2Groups = _userGroupRepo.findAll(spec);
        assertEquals(1, user2Groups.size());
        assertEquals("myGroup", user2Groups.get(0).getGroup().getName());
        
        // now allow group updates
        config.setUpdateGroup(true);
        
        User user3 = (User) suu.setupUser(request, config);
        
        assertEquals(initialGroupCount+2, _groupRepo.count());
        assertEquals(initialUserGroupCount+1, _userGroupRepo.count());        
        assertEquals(user3.getId(), user2.getId());
        
        spec = Specifications.where(UserGroupSpecs.hasUserId(user3.getId()));
        
        user2Groups = _userGroupRepo.findAll(spec);
        assertEquals(1, user2Groups.size());
        assertEquals("otherGroup", user2Groups.get(0).getGroup().getName());
    }
    
    /**
     * Test of default group handling.
     * @throws Exception
     */
    @Test
    public void testDefaultGroup() throws Exception{
        long initialGroupCount = _groupRepo.count();
        long initialUserCount = _userRepo.count();
        
        HttpServletRequest request = mockRequest();
        when(request.getHeader("group")).thenReturn("");
        
        ShibbolethUserConfiguration config = mockConfig();
        config.setDefaultGroup("");
        
        // no group and no default group
        
        ShibbolethUserUtils suu = new ShibbolethUserUtils();
        suu.setupUser(request, config);
        
        assertEquals(initialGroupCount, _groupRepo.count());
        
        config.setDefaultGroup("defaultGroup");
        when(request.getHeader("username")).thenReturn("myUsername2");
        
        User setupUser2 = (User) suu.setupUser(request, config);
        
        Group group = _groupRepo.findByName("defaultGroup");
        assertNotNull(group);
        assertEquals("defaultGroup", group.getName());
        
        Specifications<UserGroup> spec = Specifications.where(UserGroupSpecs.hasGroupId(group.getId()));
        
        List<UserGroup> findAll = _userGroupRepo.findAll(spec);
        
        assertEquals(1, findAll.size());        
        assertEquals(setupUser2, findAll.get(0).getUser());         
        assertEquals(initialUserCount+2, _userRepo.count());
    }
    
    /**
     * Test that adds two new users to same (non existing) group.
     * @throws Exception
     */
    @Test
    public void testNewUserNewGroup() throws Exception{
                        
        long initialGroupCount = _groupRepo.count();
        long initialUserGroupCount = _userGroupRepo.count();
        
        HttpServletRequest request = mockRequest();    
        ShibbolethUserConfiguration config = mockConfig();
        
        assertNull(_groupRepo.findByName("myGroup"));
        
        ShibbolethUserUtils suu = new ShibbolethUserUtils();
        User setupUser = (User) suu.setupUser(request, config);
        
        // the group should have been created
        Group group = _groupRepo.findByName("myGroup");
        assertNotNull(group);
        assertEquals("myGroup", group.getName());
        
        Specifications<UserGroup> spec = Specifications.where(UserGroupSpecs.hasUserId(setupUser.getId()));
        
        UserGroup foundUserGroup = _userGroupRepo.findOne(spec);
        assertNotNull(foundUserGroup);
        assertEquals("myGroup", foundUserGroup.getGroup().getName());
        assertEquals("myUsername", foundUserGroup.getUser().getUsername());
        assertEquals(Profile.Editor, foundUserGroup.getProfile());
        
        // the group should have been created
        assertEquals(initialGroupCount+1, _groupRepo.count());
        
        // now we test another user with the same group
        request = mockRequest();    
        when(request.getHeader("username")).thenReturn("myUsername2");
        
        User setupUser2 = (User) suu.setupUser(request, config);
        
        assertEquals(initialGroupCount+1, _groupRepo.count());
        assertEquals(initialUserGroupCount+2, _userGroupRepo.count());
        
        spec = Specifications.where(UserGroupSpecs.hasGroupId(group.getId()));
        List<Integer> findUserIds = _userGroupRepo.findUserIds(spec);
        
        assertEquals(2, findUserIds.size());
        assertTrue( findUserIds.contains(setupUser.getId()));
        assertTrue( findUserIds.contains(setupUser2.getId()));
               
    }
    
    /**
     * Test calling the setupUser method with an existing user but with a different profile.    
     * @throws Exception
     */
    @Test
    public void testDifferentProfile() throws Exception {
        
        User user = mockUser();
        user.setProfile(Profile.Reviewer);       
        _userRepo.saveAndFlush(user);
        
        ShibbolethUserUtils suu = new ShibbolethUserUtils();
        
        HttpServletRequest request = mockRequest();    
        ShibbolethUserConfiguration config = mockConfig();
        
        User setupUser = (User) suu.setupUser(request, config);
        
        // config doesn't update profile so it still should be Reviewer
        assertEquals(Profile.Reviewer, setupUser.getProfile());
        
        // now change config to allow updates, profile should change to Editor
        config.setUpdateProfile(true);

        setupUser = (User) suu.setupUser(request, config);
       
        assertUser(setupUser);        
        assertUser(_userRepo.findOneByUsername("myUsername"));
    }
    
    /**
     * Test calling the setupUser method with an existing user.
     * @throws Exception
     */
    @Test
    public void testExistingUser() throws Exception {

        long initialUserCount = _userRepo.count();
        
        User user = mockUser();
        _userRepo.saveAndFlush(user);
        
        assertEquals(initialUserCount + 1,  _userRepo.count());
        
        HttpServletRequest request = mockRequest();
        
        // change firstname header to verify that user is fetched from UserRepository
        when(request.getHeader("firstname")).thenReturn("notMyFirstname");
        
        ShibbolethUserConfiguration config = mockConfig();

        ShibbolethUserUtils suu = new ShibbolethUserUtils();
        User setupUser = (User) suu.setupUser(request, config);
        
        assertUser(setupUser);
        
        assertEquals(initialUserCount + 1,  _userRepo.count());
    }
    
    /**
     * Test calling the setupUser method with a new user.
     * The user should be created in the UserRepository.
     * @throws Exception
     */
    @Test
    public void testNewUser() throws Exception {

        long initialUserCount = _userRepo.count();
        
        HttpServletRequest request = mockRequest();
        ShibbolethUserConfiguration config = mockConfig();

        ShibbolethUserUtils suu = new ShibbolethUserUtils();

        User setupUser = (User) suu.setupUser(request, config);
        assertUser(setupUser);
       
        assertEquals(initialUserCount + 1,  _userRepo.count());

        User repoUser = _userRepo.findOneByUsername("myUsername");
        
        assertUser(repoUser);
    }
    
    private void assertUser(User user){
        assertNotNull(user);

        assertEquals("myUsername", user.getUsername());
        assertEquals("myFirstname", user.getName());
        assertEquals("mySurname", user.getSurname());
        assertEquals("myEmail@example.com", user.getEmail());
        
        Set<String> emailAddresses = user.getEmailAddresses();
        assertEquals(1, emailAddresses.size());
        
        String first = emailAddresses.iterator().next();
        assertEquals("myEmail@example.com", first);
        
        assertEquals(Profile.Editor, user.getProfile());
        
        //TODO test group
    }

    /**
     * Create a configuration object containing header keys (username,firstname,surname,email,group,profile), 
     * default group "defaultGroup" and not allowing updates of group or profile.
     * @return a configuration object.
     */
    private ShibbolethUserConfiguration mockConfig() {
        ShibbolethUserConfiguration config = new ShibbolethUserConfiguration();

        config.setUsernameKey("username");
        config.setFirstnameKey("firstname");
        config.setSurnameKey("surname");
        config.setEmailKey("email");        
        config.setGroupKey("group");
        config.setProfileKey("profile");
        
        config.setUpdateGroup(false);
        config.setUpdateProfile(false);
        config.setDefaultGroup("defaultGroup");

        return config;
    }

    /**
     * Create a mock request object returning myUsername, myFirstname, mySurname, myEmail@example.com, 
     * myGroup, editor as values for header keys username, firstname, surname, email, group, profile.
     * @return a mocked HttpServletRequest
     */
    private HttpServletRequest mockRequest() {
        HttpServletRequest request = mock(HttpServletRequest.class);
        
        when(request.getHeader("username")).thenReturn("myUsername");
        when(request.getHeader("firstname")).thenReturn("myFirstname");
        when(request.getHeader("surname")).thenReturn("mySurname");
        when(request.getHeader("email")).thenReturn("myEmail@example.com");
        when(request.getHeader("group")).thenReturn("myGroup");
        when(request.getHeader("profile")).thenReturn("editor");
        
        return request;
    }
    
    /**
     * Create a user object with myUsername, myFirstname, mySurname, myEmail@example.com, editor.
     * @return a populated User object
     */
    private User mockUser(){
        User user = new User();        
        user.setUsername("myUsername");
        user.setName("myFirstname");
        user.setSurname("mySurname");
        user.setProfile(Profile.Editor);
        user.getEmailAddresses().add("myEmail@example.com");
        
        return user;
    }
    
    /**
     * Helper method to check if a user belongs to a group.
     * @param user the user to check
     * @param groupName the group to check
     * @param groupRepository repository of all groups
     * @param userGroupRepository repository of all user groups
     * @return true if user belongs to the group, false otherwise
     */
    private static boolean isUserInGroup(User user, String groupName, GroupRepository groupRepository,
            UserGroupRepository userGroupRepository) {
        boolean inGroup = false;

        Group group = groupRepository.findByName(groupName);

        if (group != null) {
            Specifications<UserGroup> groupSpec = Specifications.where(UserGroupSpecs.hasGroupId(group.getId()));
            Specifications<UserGroup> userSpec = Specifications.where(UserGroupSpecs.hasUserId(user.getId()));
                        
            long count = userGroupRepository.count(groupSpec.and(userSpec));
            
            inGroup = count > 0;
        }

        return inGroup;
    }

}
