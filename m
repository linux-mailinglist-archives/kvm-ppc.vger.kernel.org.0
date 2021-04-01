Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 783573512F8
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 12:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233553AbhDAKDb (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 06:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233760AbhDAKDQ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Apr 2021 06:03:16 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7854BC0613E6
        for <kvm-ppc@vger.kernel.org>; Thu,  1 Apr 2021 03:03:16 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id v23so759110ple.9
        for <kvm-ppc@vger.kernel.org>; Thu, 01 Apr 2021 03:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=WLVHzoY7kPaQyg4hZLaFyzDphqotEQv7gB0kf6T3rrU=;
        b=RTy5M/zEUbjIkP3tWMMio3i59MK84fjewY/cIXFkXZv+Yj31pJt++9nPte+2ocpaMs
         zy6+ZczFT8gkowkrJzbhxiHSwSDrN7G0VH/EY5B7KxMopmkFzpekbp7gun5xsakPwluL
         /LmWkIhA8m/3KrsbJBYQZ1DLNAmZvmRcJRa0U2e3Bkhh504ECHJlGi1aY8qC7BA+V+35
         kejvQAGkeMHTdh+kVKE5CZY1ijSlzhlfSFFZNhbZZsAv7Sl7AWZ4x/2MsNzwPeXLqbTP
         nS4G/jK9JiUpTsKj6ukRk17TPl5VLSKA78vCQQeJz/oxSx7M6sJ8CedRL1CHNLNJcVwc
         oIUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=WLVHzoY7kPaQyg4hZLaFyzDphqotEQv7gB0kf6T3rrU=;
        b=KqXDDyEsJGJ98E/7/I3KgZBacyMmNoCSRXG2uy82tJZiIKfs5XTSwQkowRhba8YrWq
         lloDIlK1WiqxtDj8vn1jLZdhww9RBnJBTggb0XzNdXk3qTgeyJ8DT0rIVEZAWIqeZ9cs
         +9emuK5/03WztVm2PlGxHE0FAnmo9SL8seNlgl0uqziINlMjF6VrqG6qIM7rOMGIuQIi
         PXyucfjOKhYcH/u60um2zOPNqeev0srQvxPrtlwyZp744+FLgI+LDn3HAbEpXwZhnu9A
         diSzVP3gmGd7Jrc33DWPVl8Q3xa59XXBqLFIkaoUKvZluk0hUFn3EIfsyhI/POZ/bg0D
         F9ZA==
X-Gm-Message-State: AOAM530LFPjr8bgzg2bgfjOBPDH1x+wZKPjMdGcGbjsNk2yZ/9p+1IlZ
        8F9oUTW1Z1/9c1oOsmwJ6FU=
X-Google-Smtp-Source: ABdhPJyRKHT6ILo69/SWLcrVFAXW427EIqTd2DbkN8dP7C0XjCTDD1CdF6m+NPDJm0MCII5ulMd0cg==
X-Received: by 2002:a17:90a:f02:: with SMTP id 2mr7993758pjy.209.1617271396085;
        Thu, 01 Apr 2021 03:03:16 -0700 (PDT)
Received: from localhost ([1.128.221.56])
        by smtp.gmail.com with ESMTPSA id e1sm4960397pfi.175.2021.04.01.03.03.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 03:03:15 -0700 (PDT)
Date:   Thu, 01 Apr 2021 20:03:10 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v4 15/46] KVM: PPC: Book3S 64: Move hcall early register
 setup to KVM
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
References: <20210323010305.1045293-1-npiggin@gmail.com>
        <20210323010305.1045293-16-npiggin@gmail.com>
        <YGVdFrsEtD88oB90@thinks.paulus.ozlabs.org>
In-Reply-To: <YGVdFrsEtD88oB90@thinks.paulus.ozlabs.org>
MIME-Version: 1.0
Message-Id: <1617271255.sz2p0e41kb.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Paul Mackerras's message of April 1, 2021 3:41 pm:
> On Tue, Mar 23, 2021 at 11:02:34AM +1000, Nicholas Piggin wrote:
>> System calls / hcalls have a different calling convention than
>> other interrupts, so there is code in the KVMTEST to massage these
>> into the same form as other interrupt handlers.
>>=20
>> Move this work into the KVM hcall handler. This means teaching KVM
>> a little more about the low level interrupt handler setup, PACA save
>> areas, etc., although that's not obviously worse than the current
>> approach of coming up with an entirely different interrupt register
>> / save convention.
>=20
> [snip]
>=20
>> @@ -1964,29 +1948,8 @@ EXC_VIRT_END(system_call, 0x4c00, 0x100)
>> =20
>>  #ifdef CONFIG_KVM_BOOK3S_64_HANDLER
>>  TRAMP_REAL_BEGIN(system_call_kvm)
>> -	/*
>> -	 * This is a hcall, so register convention is as above, with these
>> -	 * differences:
>=20
> I haven't checked all the code changes in detail yet, but this comment
> at least is slightly misleading, since under PR KVM, system calls (to
> the guest kernel) and hypercalls both come through this path.

Yeah good point, I'll update the comment at its destination.

Thanks,
Nick
