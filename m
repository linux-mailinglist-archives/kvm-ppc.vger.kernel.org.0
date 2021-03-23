Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6BD34546C
	for <lists+kvm-ppc@lfdr.de>; Tue, 23 Mar 2021 02:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbhCWBDp (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Mar 2021 21:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbhCWBD2 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Mar 2021 21:03:28 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1A1BC061756
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:03:27 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id c204so12522662pfc.4
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Kb34vWpXzgWUzoINnJbe4T3qARQM/1MOi4byEufbLGk=;
        b=N37jRf32sH+nM4T5mCFVIebh7kiOsFRboJjmJBOb6Qh214ZpzGu7vSUydn/3DwdGS0
         1LAF3b/kA7Ispthu5NxeIPm6a393TKiq2DOBSbXUCBio6eQFkcJIEHlrzJA7CWGrKW+y
         OudhzKoFqn5UCY//cG/SkOCSJhK6uKSeGWZeFy1QYj82zHUD5rMis91JHTDGBhX0/Bxw
         nmVvdvzYGWODHOuDcOhRgvIy4SP/c/D2LLXvA/RUkhp9sWUhQYtPKI4ax/yStWHnRuJ+
         X22LC0NW19iq49sUaoObJbGiHX5ojbNY40LyzuZr4YqN4iIMuFZlocSGsPQV83h6OIMA
         P7rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Kb34vWpXzgWUzoINnJbe4T3qARQM/1MOi4byEufbLGk=;
        b=l6V9FY0m8zZhi0TTj4jjA9jyWFPYJN1T92dvjeZtEzqFRK/b4r8lCYBlz2PB1XE4Pt
         f04eLGTH35l/YKmqkHLInULW1BfENuv49T5hGGylTykSO9vFlbTONcLp+EHo5XzvGCP0
         Mh+hraFDt0NShr+CG0QXTYvjvPhznlWb7/pIad2ip3aYiNrj1ARbFjzI1uK8/YtkL3VG
         BBbwovQukEJqDGfF4b2fvod++Z/f7Q3NagR6kg94s9xJIwFZ7pgEUd/TkBgh208PQ7Eq
         3zVex7RV1Rqjha3iw4StWFRpJwn+T7GcjS4d0hdMl578GBLH5B6BqKPfASwJaxWP5c1q
         3w2A==
X-Gm-Message-State: AOAM531JpJFRrrh0aBkshQnqJnARfJHel3jz5yHy7OyIdFofeN1tEzr5
        vNj93qFEMooFEup1eU0MGmzyDRADZMg=
X-Google-Smtp-Source: ABdhPJw0jC7eGSE+tizBJpsnpVKghO7RDXRyMrrhaMy7VyPtiTOpOreBXVh6VamK/ZHR9pFkWMeWgw==
X-Received: by 2002:a17:902:d341:b029:e6:9a9f:5614 with SMTP id l1-20020a170902d341b02900e69a9f5614mr2276114plk.48.1616461406873;
        Mon, 22 Mar 2021 18:03:26 -0700 (PDT)
Received: from bobo.ibm.com ([58.84.78.96])
        by smtp.gmail.com with ESMTPSA id e7sm14491894pfc.88.2021.03.22.18.03.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 18:03:26 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v4 03/46] KVM: PPC: Book3S HV: Disallow LPCR[AIL] to be set to 1 or 2
Date:   Tue, 23 Mar 2021 11:02:22 +1000
Message-Id: <20210323010305.1045293-4-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210323010305.1045293-1-npiggin@gmail.com>
References: <20210323010305.1045293-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

These are already disallowed by H_SET_MODE from the guest, also disallow
these by updating LPCR directly.

AIL modes can affect the host interrupt behaviour while the guest LPCR
value is set, so filter it here too.

Suggested-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index c4539c38c639..c5de7e3f22b6 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -803,7 +803,10 @@ static int kvmppc_h_set_mode(struct kvm_vcpu *vcpu, unsigned long mflags,
 		vcpu->arch.dawrx1 = value2;
 		return H_SUCCESS;
 	case H_SET_MODE_RESOURCE_ADDR_TRANS_MODE:
-		/* KVM does not support mflags=2 (AIL=2) */
+		/*
+		 * KVM does not support mflags=2 (AIL=2) and AIL=1 is reserved.
+		 * Keep this in synch with kvmppc_filter_guest_lpcr_hv.
+		 */
 		if (mflags != 0 && mflags != 3)
 			return H_UNSUPPORTED_FLAG_START;
 		return H_TOO_HARD;
@@ -1645,6 +1648,8 @@ unsigned long kvmppc_filter_lpcr_hv(struct kvmppc_vcore *vc, unsigned long lpcr)
 	/* On POWER8 and above, userspace can modify AIL */
 	if (!cpu_has_feature(CPU_FTR_ARCH_207S))
 		lpcr &= ~LPCR_AIL;
+	if ((lpcr & LPCR_AIL) != LPCR_AIL_3)
+		lpcr &= ~LPCR_AIL; /* LPCR[AIL]=1/2 is disallowed */
 
 	/*
 	 * On POWER9, allow userspace to enable large decrementer for the
-- 
2.23.0

