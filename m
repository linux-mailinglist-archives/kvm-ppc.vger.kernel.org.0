Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5791920C29D
	for <lists+kvm-ppc@lfdr.de>; Sat, 27 Jun 2020 17:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbgF0PEo (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 27 Jun 2020 11:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbgF0PEn (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 27 Jun 2020 11:04:43 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15846C061794
        for <kvm-ppc@vger.kernel.org>; Sat, 27 Jun 2020 08:04:43 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id a6so10766295wmm.0
        for <kvm-ppc@vger.kernel.org>; Sat, 27 Jun 2020 08:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Awl2+Dc84pQS8EzxldlSJeEwx2uf/L+aZYvfx6Px2Ys=;
        b=GDfnQLNCjBrdUZQ8qkyI7bF7evpAV+G5A2n0GySEIkc6XcnUmURExoJ8n/6u7TqhWu
         H4BmcQPWlR2afJdhBNTX71eh5V77xt2/pYQGdsW6xrXEv21F2gkKjL+uT53h8nU46Yj7
         K9OzUCGyUIvIPOir3LueFvDgZW301eFX8/Js4kGKdPNy8Ci/BxQpTujVCPYCOmhhJR3r
         +HPGKMXVUerIe/JSZLBKi5Bauqx0IZDux5A7DBsKTjZ4ST5xaf2W0br4YyAM3R6S2KYv
         8Vy+niBw05j4FslzlWxSwJmvFfcN4vWt3xXz6wtc0Z+lKjhRlc6RKGEm0TK/xo+EINn3
         Kurw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Awl2+Dc84pQS8EzxldlSJeEwx2uf/L+aZYvfx6Px2Ys=;
        b=rMdD60qhizRaJsmTk/b2HmcwZDcQXpCeHi+z+vtzIu18Ry9OWQr6Yb/uZuA7XYcNA0
         dN0i10FmVu9K9z/AMoaZeQySMKfPzL476gg/K2p+X04B1hdWUC6dLNS8rF1j+oMFbiMO
         /LxH9cKJfOnfRSYqSNIWDaIclyx+OjbQIY/ZlkEEWu8qY9DNzskzIm9vPpTPl12NjhdP
         P/1JOEOjbFD2XZzcTYeSulN2XVhLEZOzdQWuE7OFoRfAFvmEXr+YOIHkUaHlRmcgLe8Y
         xAs8Tbve46UL51NdND3SYyc0TG798ragpD0vYj1XEiiH9FJuGx9rAquaYv9Tdh77vfDY
         VL2w==
X-Gm-Message-State: AOAM532TOLLmF1vfFPNRKdgUMWaY6n3qH56PgDf0ZnpeZsEa9GsNvvKM
        xcasShEEXzG+HjF5lXUJqgA=
X-Google-Smtp-Source: ABdhPJydYKhNv8V62RpFGbSQwGzEQ0A4XVBchhpf8civ1Im7u8WD89P9Zo0bs0VKz6JDlh/ly07ckg==
X-Received: by 2002:a1c:7e94:: with SMTP id z142mr8458109wmc.124.1593270281597;
        Sat, 27 Jun 2020 08:04:41 -0700 (PDT)
Received: from bobo.ibm.com (61-68-186-125.tpgi.com.au. [61.68.186.125])
        by smtp.gmail.com with ESMTPSA id d132sm21722029wmd.35.2020.06.27.08.04.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Jun 2020 08:04:41 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Anton Blanchard <anton@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org
Subject: [PATCH 0/3] powerpc/pseries: IPI doorbell improvements
Date:   Sun, 28 Jun 2020 01:04:25 +1000
Message-Id: <20200627150428.2525192-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Thanks for the review, I think I incorporated all your comments, I
also did add KVM detection which avoids introducing a performance
regression.

Thanks,
Nick

Nicholas Piggin (3):
  powerpc: inline doorbell sending functions
  powerpc/pseries: Use doorbells even if XIVE is available
  powerpc/pseries: Add KVM guest doorbell restrictions

 arch/powerpc/include/asm/dbell.h          | 59 +++++++++++++++++++--
 arch/powerpc/include/asm/firmware.h       |  2 +
 arch/powerpc/include/asm/kvm_para.h       | 26 ++--------
 arch/powerpc/kernel/dbell.c               | 55 --------------------
 arch/powerpc/platforms/pseries/firmware.c | 14 +++++
 arch/powerpc/platforms/pseries/smp.c      | 62 ++++++++++++++++-------
 6 files changed, 119 insertions(+), 99 deletions(-)

-- 
2.23.0

