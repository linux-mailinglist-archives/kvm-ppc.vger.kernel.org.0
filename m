Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C35C20F3D2
	for <lists+kvm-ppc@lfdr.de>; Tue, 30 Jun 2020 13:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732228AbgF3Luu (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 30 Jun 2020 07:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729580AbgF3Lut (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 30 Jun 2020 07:50:49 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E01C061755
        for <kvm-ppc@vger.kernel.org>; Tue, 30 Jun 2020 04:50:49 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id g75so18501496wme.5
        for <kvm-ppc@vger.kernel.org>; Tue, 30 Jun 2020 04:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P2kaWfnNvd2hN2fmZl/iANXKvq3Zrz+qKXWCTOlr4ZQ=;
        b=sv5METmcUNlVPL/aF13yHN3RqTEDxyG7/q2ECvPsTEirhsBYrD8bvvnpPRSjeGjFB8
         JmWn5L5WpSXZW+e8A7oIxPlEngvk5HSJt3GaoLlrHHDCjxuSGGtqy12ELnDPgvHF+Xoo
         GCPbEn37jqhnTSCSVN6rQ8PA5enmiryKt9xjLw0Rw1QcTaKlknuZjGdd+QEOdbckgKJm
         CfEFyNn3f/SbCi7AF2mgOMvzBO72r2mQRoXHHDw6JncweKSnEZZkXAuWH/8VQbJPagj1
         QC5DEACTyIuIPgj11L5cdGLCKpNW/Wo1GHFtY7pQTL/v88z3c9ArhH1JBaWJY+fdDHHK
         GCAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P2kaWfnNvd2hN2fmZl/iANXKvq3Zrz+qKXWCTOlr4ZQ=;
        b=N+GcHkAcXBUKHCETKIoIJYAPgwCSFFjMPvw3Cb+cQ61P8YeqhB8Ja78c3gKHLjAN42
         6Pvc0O7PYEEtwwPZf8LUDNinkKDkQvRGKk8oLYTjoZsI+/Gn5MZ1GPB+HMeSSmJfAB1i
         A+BP8jJ1p3LVPmfnoSAdwhQ/8QxjDMCXPCqkR/dJBq8yjaXbQpgqx2G426AyCJyfbcut
         0cGVxl/Gv+cqB1yPf6oahqtIslgcgHej9bQ0J741nWtUDoP6VN73LLvsnbH4VUf76dIi
         +uKUUPE+oTMautgS619g9HGJm44HUHBXx6Zg+woKxhUDKSF+MSeV/8Q1DdVWhmFgaQuw
         sYGg==
X-Gm-Message-State: AOAM5316giQXkSOIL5vkX8FFwXYeExKuxTh4xgGnQp+Dk8t+tEjWlq1G
        Vz81PZJcxRpMmF8UuQ7tigFn/Rgm
X-Google-Smtp-Source: ABdhPJy4nPCZZHjQR/ImHJv5iiYOplIlPtzwEscgSm2rMCey7bQHLnriQSfQbHJg8/bFfHmIs+IqoA==
X-Received: by 2002:a05:600c:294a:: with SMTP id n10mr20315557wmd.38.1593517848074;
        Tue, 30 Jun 2020 04:50:48 -0700 (PDT)
Received: from bobo.ibm.com (61-68-186-125.tpgi.com.au. [61.68.186.125])
        by smtp.gmail.com with ESMTPSA id c25sm3133673wml.46.2020.06.30.04.50.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 04:50:47 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Anton Blanchard <anton@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@samba.org>, kvm-ppc@vger.kernel.org
Subject: [PATCH v2 0/3] powerpc/pseries: IPI doorbell improvements
Date:   Tue, 30 Jun 2020 21:50:30 +1000
Message-Id: <20200630115034.137050-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Since v1:
- Fixed SMP compile error.
- Fixed EPAPR / KVM_GUEST breakage.
- Expanded patch 3 changelog a bit.

Thanks,
Nick

Nicholas Piggin (3):
  powerpc: inline doorbell sending functions
  powerpc/pseries: Use doorbells even if XIVE is available
  powerpc/pseries: Add KVM guest doorbell restrictions

 arch/powerpc/include/asm/dbell.h     | 63 ++++++++++++++++++++++++++--
 arch/powerpc/include/asm/firmware.h  |  6 +++
 arch/powerpc/include/asm/kvm_para.h  | 26 ++----------
 arch/powerpc/kernel/Makefile         |  5 +--
 arch/powerpc/kernel/dbell.c          | 55 ------------------------
 arch/powerpc/kernel/firmware.c       | 19 +++++++++
 arch/powerpc/platforms/pseries/smp.c | 62 +++++++++++++++++++--------
 7 files changed, 134 insertions(+), 102 deletions(-)

-- 
2.23.0

