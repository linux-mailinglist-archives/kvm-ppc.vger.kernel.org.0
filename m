Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B710735243E
	for <lists+kvm-ppc@lfdr.de>; Fri,  2 Apr 2021 02:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234374AbhDBAHP (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 20:07:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233677AbhDBAHP (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Apr 2021 20:07:15 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19236C0613E6
        for <kvm-ppc@vger.kernel.org>; Thu,  1 Apr 2021 17:07:15 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id v186so2584305pgv.7
        for <kvm-ppc@vger.kernel.org>; Thu, 01 Apr 2021 17:07:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=TjZFJ/jiE4hyJ0wDhmUN0lOgew0goUXGPWz316MpjMU=;
        b=MfwNQI5HhOqUMd8PUmdZOeMX3jJ4REhmnSB8kxLzl/tSa86T58Mg9dif+FEGCkkzd1
         m42dO1+V9JTciOnbxpaTS6pXFDQwI8oA2eQ8NK6MgHuW0sLce7wY0yEOQYzinGhclyZT
         RCfBnQJ4L1QS9qqSXnGFa0feM0SNsjMf6oOBH3ddTLXAuY2ucAohBuP9anAoKnRIwO1+
         SEHC17XpcxgI8Jd3RIPZEPPVsyB6VZzz/QXAZjwXUBOiAMiQG1fhs0k+3BGNkv69aZW+
         XbUEqs0GTyx7JssnnRMTPSAzap52bHrt7YKGNGPWqUhciDPbY0L3OfadY6Ng9/Ga+aE0
         0bPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=TjZFJ/jiE4hyJ0wDhmUN0lOgew0goUXGPWz316MpjMU=;
        b=HvBGS1k0R+tny6jI+WEyTmJPUDWzn60BXCTuflcQN/XvwJ75sKute8eoaC60mmrhmE
         A48u5E0uL5w+RIsX75LlRkhb0CUaptKUDAIFWtvqV/+hpEea/pwEav/07jADN4ej1TFB
         rPek/lOeh335aN0CLN2gmOEmE8VdKCe+uwJlBDSP+wTYZsclV2g3ASUNBz46eYCsYiA6
         mh4CEMLvxfU4ac5VJWwmgmwc0aExaXkuree1PkFPtPxpwGoEtpwwwk8AOdbQRsRN7PmM
         qVX2aUDriq1VuqBs5vi0bWohb+pWrida2FGTuiLv75o9WZtsd6DtLjkcds06RAfTyNC0
         +oOw==
X-Gm-Message-State: AOAM530u4nNhwvD66sH2x6SvdTQWDQYVp7eZphrhNPfG1n4bNJglh8tR
        L+CLaLKmvbSMHMFmnW/0YTH8/Tldlrh31A==
X-Google-Smtp-Source: ABdhPJya8iyB3S5J3LYyRYA559frJsgIyppIVxik21hbdM4U6DVQUq/6cku91AF/RQoqe6J7S8n/qw==
X-Received: by 2002:a65:6a43:: with SMTP id o3mr9667932pgu.297.1617322034459;
        Thu, 01 Apr 2021 17:07:14 -0700 (PDT)
Received: from localhost ([1.128.154.184])
        by smtp.gmail.com with ESMTPSA id y7sm6340701pja.25.2021.04.01.17.07.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 17:07:14 -0700 (PDT)
Date:   Fri, 02 Apr 2021 10:07:07 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v5 42/48] KVM: PPC: Book3S HV: Radix guests should not
 have userspace hcalls reflected to them
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210401150325.442125-1-npiggin@gmail.com>
        <20210401150325.442125-43-npiggin@gmail.com>
In-Reply-To: <20210401150325.442125-43-npiggin@gmail.com>
MIME-Version: 1.0
Message-Id: <1617321866.blku87d7ps.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Nicholas Piggin's message of April 2, 2021 1:03 am:
> The reflection of sc 1 hcalls from PR=3D1 userspace is required to suppor=
t
> PR KVM. Radix guests don't support PR KVM nor do they support nested
> hash guests, so this sc 1 reflection can be removed from radix guests.
> Cause a privileged program check instead, which is less surprising.

I'm thinking twice about where to put this patch. This is kind of
backwards (but also kind of not), so I decided instead to make
the change to not reflect on radix in the patch that removes real
mode hcall handlers from the P9 path.

And the patch around this part of the series will introduce reflection
for hash guest support in the P9 path.

End result is the same but I think that works better.

Thanks,
Nick
