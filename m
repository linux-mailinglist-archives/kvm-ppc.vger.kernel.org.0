Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD87211C94
	for <lists+kvm-ppc@lfdr.de>; Thu,  2 Jul 2020 09:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbgGBHWM (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 2 Jul 2020 03:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbgGBHWL (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 2 Jul 2020 03:22:11 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B68FBC08C5C1
        for <kvm-ppc@vger.kernel.org>; Thu,  2 Jul 2020 00:22:11 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id h22so12145618pjf.1
        for <kvm-ppc@vger.kernel.org>; Thu, 02 Jul 2020 00:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:message-id:date:user-agent:mime-version:content-language
         :content-transfer-encoding;
        bh=IM8OcCd1J5H5NYYxqt8/UURDJnjX3/PpwHj5eTTFHqg=;
        b=pOAkwY3cCB11ZLmjjIqhc1xk2fSYmSP9+twK7x1Zl82aOYD9sRSStHDz/rVjC1ITCP
         TMh6SIUz2YFLP4/Qw3O+V8tGZ6KQFIqJ7oFufIe5cJLXbuKml4WL8R5NkoOKib74Eq0V
         bWg6wN9ckkkzbmpGYCmyAK095PJJHDqMCfN7uuha0thw0UjTHn4XKycToG5zCEQR0+9r
         7bTW43id3/p9HmVYmj+3ABIEEG7biFbCu9g3NKTWTzwRhKOdIXrvk7wD5K/lEiaLplJ+
         2VtnXr5fSpWpwhlvSYPFlK6fxlEpIy46NZjCyV+Mnzm1ItkAMX3xaIi+OOVUYw/aRS0z
         pMfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=IM8OcCd1J5H5NYYxqt8/UURDJnjX3/PpwHj5eTTFHqg=;
        b=EC+nd/rGh4gukAjjDBR34+/Xn+0+5UpjDZ0gI0i+p4Q/7RcykaZAUVAcbO6u96N56v
         lHvkddyRODQwige+JdBoko41AgqZA79lhfJ8o/m3Nm18IzY/+fYUFl6T5kHC8FlmuTHF
         /ADnZNXBHFUff0A4Xkjm5Osp90M9BY+iLo43pnl+zQQgWG7+q1lY5vmsEPdoGNJveLmz
         DW3K6EnmgK7nUJAVmIksV9BDqm4PQa8dDgluo6zvImxjkr33vOJqUlf3FmK7NtUpGVAA
         Ml2fVupE6KKR2JQfx6763GGx69USV1Fr74B4gZslsUX3bsdQToujcpBIPC4vtIvKnfB9
         GKqQ==
X-Gm-Message-State: AOAM533p5zEB7Xy9gellYVfRGCWyls/X+uC0JuIfaXRisqLn18SClRhu
        iKzVwQ1Vzzu4a+7DJjqa2HL5n1S5
X-Google-Smtp-Source: ABdhPJxNRm+AwTmnsjcjAy46T4/vbs5iLx6L91lWDGctU4njoA7i9xflHX2hIPFZdVWsTZ4e/jq6qg==
X-Received: by 2002:a17:90b:388d:: with SMTP id mu13mr30271474pjb.187.1593674530915;
        Thu, 02 Jul 2020 00:22:10 -0700 (PDT)
Received: from JAVRIS.in.ibm.com ([49.206.9.181])
        by smtp.gmail.com with ESMTPSA id t184sm7923914pfd.49.2020.07.02.00.22.09
        for <kvm-ppc@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jul 2020 00:22:10 -0700 (PDT)
To:     kvm-ppc@vger.kernel.org
From:   Kamalesh Babulal <kamalesh.babulal@gmail.com>
Message-ID: <6ba94eab-8dfe-fdd0-20db-2cff98718f06@gmail.com>
Date:   Thu, 2 Jul 2020 12:51:58 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Subscribe
