        Integer userId = (Integer) auth.getPrincipal();
        this.userMedalService.updateProgress(userId, Medal.SYRY, 1, 2);
        return ApiResponse.defaultSuccessResult("上报成功", null);
