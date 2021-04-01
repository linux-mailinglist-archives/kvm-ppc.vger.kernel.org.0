Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBD93512B6
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 11:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232585AbhDAJt5 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 05:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233629AbhDAJta (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Apr 2021 05:49:30 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27915C0613E6
        for <kvm-ppc@vger.kernel.org>; Thu,  1 Apr 2021 02:49:30 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id ay2so757039plb.3
        for <kvm-ppc@vger.kernel.org>; Thu, 01 Apr 2021 02:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=LWrLsc7U/Y59RvQVrIOPJZyoQyt2UXhRFGQ6YveYHww=;
        b=FIEsx+EncqLUUJj9AjtyYn3npxPJJollHq6dZ56xEFFvX53Z8iHWgUCb8JqqcgSUSs
         PjPzwePxZHLRi269igCb6iVW4e00T56HvL7cZdP+dIL+eU+funRd//JeHZQLTNmpAwzP
         mlwDeIiBq8qrjSVWYqa11U2dUH0jgISgxL7QcXYWJjF6FzZljBYMhb1myHJNzq7ZcnKe
         so3NBZpu26MkGF6tQXhuZk9qhXVcfS8GVr8z4FKEyGgyYchKWMlWCPcloOLC42HcDQK4
         kiPNIEHPZBClEcojcEw/KYOOiFYJ8bxEoxYxY4ekkgrgqcmKDIHBa7k1BOTHmHWM1SKZ
         z6MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=LWrLsc7U/Y59RvQVrIOPJZyoQyt2UXhRFGQ6YveYHww=;
        b=tUI6EJUCEb0j6Zq1udZXCnknmJnn5XCztXY0u0zOoxr0sk3fN5x+ecxLN65XTCZ3/y
         xzu1vuUm5K/mVNekIiUHtpOms9nk6nJ2mz219jTjOFEEv6buGleyeB6FHD7PkNkHDJRv
         mIr7oDF/i3q81toYQJkw9xFQUjaza/qkPsQx8nnsW1Kl8eVAXPeVEi0fR/Vor03wILub
         U6eMRwLZxn6jzPiemFU75iU6h5737Gv9GxD286Lm8G3gYoTHooWCdVO2yDO15TPDvCE5
         hIvS3RIo6bKOZ2A52JlwFLa9Fojx1/t3NeqtF+tBp2M1PoHVQj6WDgZgwqvyNkEL4GG9
         oiBQ==
X-Gm-Message-State: AOAM532zoXjWu1x1pd9gmZHqC1I7S+t+EjVpT3BWC7TyTvYzAWLwvDMN
        e3KpbXa4XZjqyIedZOGSNts/0FgDDR0QkA==
X-Google-Smtp-Source: ABdhPJyoham8uTT+KgHOmDWwfrW4nRhuzu5ssWNL2ldPpSoB4ofe5HKDsyD/SvBLKfDeqyditEt7aA==
X-Received: by 2002:a17:902:23:b029:e7:32b7:e760 with SMTP id 32-20020a1709020023b02900e732b7e760mr7069600pla.55.1617270569806;
        Thu, 01 Apr 2021 02:49:29 -0700 (PDT)
Received: from localhost ([1.128.219.229])
        by smtp.gmail.com with ESMTPSA id gz12sm5099146pjb.33.2021.04.01.02.49.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 02:49:29 -0700 (PDT)
Date:   Thu, 01 Apr 2021 19:49:24 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v4 11/46] KVM: PPC: Book3S HV: Ensure MSR[HV] is always
 clear in guest MSR
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
References: <20210323010305.1045293-1-npiggin@gmail.com>
        <20210323010305.1045293-12-npiggin@gmail.com>
        <YGQBdVntWnG/ewtj@thinks.paulus.ozlabs.org>
In-Reply-To: <YGQBdVntWnG/ewtj@thinks.paulus.ozlabs.org>
MIME-Version: 1.0
Message-Id: <1617270525.5034ks2srs.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Paul Mackerras's message of March 31, 2021 2:58 pm:
> On Tue, Mar 23, 2021 at 11:02:30AM +1000, Nicholas Piggin wrote:
>> Rather than clear the HV bit from the MSR at guest entry, make it clear
>> that the hypervisor does not allow the guest to set the bit.
>>=20
>> The HV clear is kept in guest entry for now, but a future patch will
>> warn if it's not present.
>=20
> Will warn if it *is* present, surely?

Just making sure you were awake, definitely wasn't a copy-paste bug...

Thanks,
Nick

>=20
>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>=20
> Acked-by: Paul Mackerras <paulus@ozlabs.org>
>=20
