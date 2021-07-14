Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA393C93D8
	for <lists+kvm-ppc@lfdr.de>; Thu, 15 Jul 2021 00:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbhGNWdc (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 14 Jul 2021 18:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230441AbhGNWdb (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 14 Jul 2021 18:33:31 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE13C06175F
        for <kvm-ppc@vger.kernel.org>; Wed, 14 Jul 2021 15:30:38 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id k11-20020aa792cb0000b02903305e16bd1dso2718236pfa.2
        for <kvm-ppc@vger.kernel.org>; Wed, 14 Jul 2021 15:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=oy+6fSOgVvelfBYqm9I93gxvw6Do50+x0vRkEpIyCfY=;
        b=tz16AEtKfG2EUdC15bPbUk+WUL8riHoR54VGvb+lkRLbJSzwSKPUphDFP2c8XJB2oD
         tRYeCifFwWDoNGRPbOXzhhikKdnEbrV+GSotLdSVMUToZ9YZRkeyBxMJ2fGBXQVSsO/K
         CES1+CuKoDT1pf7ZHWoVYbxUSeqhJo64Pp0QRbSgnD1IltKWfSHsYw/I46T2ge7j91fu
         wTffFeqfZi+q0Ejvj6N6HCQObQkcXDAYGTcT77s3U+QmKH9wk9M5r4wUFq7pXrjDGmFq
         nh1G3rMYh80gn1phbAK8odckwhq3QmEjs9AZA9nzXcUwXS0di14/5auHXCNJ1ZJeheAY
         yOWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=oy+6fSOgVvelfBYqm9I93gxvw6Do50+x0vRkEpIyCfY=;
        b=ADzlKYqRoV93JxYtNHzhaRBV5b+rfYL/f5+rAKVFs2Nv6LfOwEJusI/kve4cVaAhvK
         zw1Qn5xLdCFbMxgxNHI+XuRCXCPaLlJ59sp7bWGfQzR2NTEw9XNGz8TtiDeYdSCFmyF8
         Ovk39vx7m7o+itzkAZN+PbAL+MUI9OqPNvrnNAe3SeZdx5mHRZicOyC/ywIS1SWVcgef
         C/DXUFPeitxJ9FL71+66J/A8P1MypauT3mDrg46MSIWFNnG6SouX6sC3frzn3knOXVFF
         JmJU84if9OzaCZB3PnxLT+aOfIcyocAXN3O9ygMOECH7LStSZWXcsGACwKo6poQBtI75
         dbQw==
X-Gm-Message-State: AOAM532GPYbX9LKyQ7N7NozXiMpto1Rj2P6IMLoyy3T3+sc+T+jdhApW
        n0+heHWXPXEVRSPg8qo1bbpPgptjwa+wh65URg==
X-Google-Smtp-Source: ABdhPJyiuRd2/a1tYiN3eAIKGn0ap+o/F3PZnCFaTGnmlVbtxFslorqTMKuMd+q3l23RLWc4YyKMa8KF4idDns/yFQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:902:b288:b029:12b:533e:5ea0 with
 SMTP id u8-20020a170902b288b029012b533e5ea0mr209491plr.44.1626301838387; Wed,
 14 Jul 2021 15:30:38 -0700 (PDT)
Date:   Wed, 14 Jul 2021 22:30:28 +0000
In-Reply-To: <20210714223033.742261-1-jingzhangos@google.com>
Message-Id: <20210714223033.742261-2-jingzhangos@google.com>
Mime-Version: 1.0
References: <20210714223033.742261-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v2 1/6] KVM: stats: Add capability description for KVM binary stats
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Rientjes <rientjes@google.com>,
        David Matlack <dmatlack@google.com>
Cc:     Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The binary stats capability description was lost during merge of
the binary stats patch.

Fixes: fdc09ddd4064 ("KVM: stats: Add documentation for binary statistics interface")

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 Documentation/virt/kvm/api.rst | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index b9ddce5638f5..889b19a58b33 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7241,3 +7241,11 @@ The argument to KVM_ENABLE_CAP is also a bitmask, and must be a subset
 of the result of KVM_CHECK_EXTENSION.  KVM will forward to userspace
 the hypercalls whose corresponding bit is in the argument, and return
 ENOSYS for the others.
+
+8.35 KVM_CAP_BINARY_STATS_FD
+----------------------------
+
+:Architectures: all
+
+This capability indicates the feature that userspace can get a file descriptor
+for every VM and VCPU to read statistics data in binary format.
-- 
2.32.0.402.g57bb445576-goog

