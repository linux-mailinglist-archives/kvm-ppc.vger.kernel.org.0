Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B52354D44
	for <lists+kvm-ppc@lfdr.de>; Tue,  6 Apr 2021 09:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238412AbhDFHFO (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 6 Apr 2021 03:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238404AbhDFHFN (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 6 Apr 2021 03:05:13 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC53C06174A
        for <kvm-ppc@vger.kernel.org>; Tue,  6 Apr 2021 00:05:05 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id 11so8048810pfn.9
        for <kvm-ppc@vger.kernel.org>; Tue, 06 Apr 2021 00:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=uS28LyyI+bi1kiY9qrGEaoICmXPsK96cE5clEwvIrlg=;
        b=sSdhwSHAEMAVPq/5SsZDPjDoQcLo+Zikg+iGPRxKIf5+QYQbULlfuzEinZ25/EKbhJ
         GwInAZPZnHPChlXonmvJv9wBJpe57D4161koWuqYKabgoaHxIdpdHdqVcvIYzwVa7A2F
         Y1jGyPxyWa3G3bxKJsWds70VNd+boE5ceZ7ya6lV0rqBlHl5SP9vK7KNjfnVOlwSYd3y
         +SoZaQbhFc9uhojgKwcDEdsT438f2Fo//g21WRjdoyKHHXB5tsyvuQpD8vF6aLBng4Uu
         pHiHTzoemc7RBhLPf/mW8Xm8UoO9GmwiYBjTLVP40s6G9AE3DOPJnsYsZl4HslrUvuBm
         8cGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=uS28LyyI+bi1kiY9qrGEaoICmXPsK96cE5clEwvIrlg=;
        b=Z0PThsYg65HiTLOVPZl6iyLO6LovL0hFYk97OrrSKozLLQO6uKrE9iRkEwFrH0q8ES
         0xoa1hn8mD5vtrkVgBPHHobTHoRwxr70NKptBqBoSBlKJK/XW6WfvdVpzcXSszH9e3gj
         a0jD2OlHmx94uIp9O7gsSp2klSWZKO909s7HkI6hCe1WPdxOXhqaYq0UthZGwAUZ+a/p
         CHfs6N2wPhGbI9QuCk57vbyTluAzdiJ92cNhkJasBfSQ9C9oYhFmaqHH58NgSwv2tAoh
         WXjE12m7PAsZ3sicnmoodutp9HYkmXCSRW1NEIdV7xaD+BlkKOfjyy6lfErJcT8obhrT
         9uSA==
X-Gm-Message-State: AOAM531uD0KExx00JspEW07IXXbK2qOoLpExgyKbtPaaqoRSieeZzw5r
        tIFNSghJGcabK1xC5UpFNlI7rjMy5bQ=
X-Google-Smtp-Source: ABdhPJysgIrCHm/aCWkegmz+8NxzSXzD7Ogyz29u24a/n5t1b7BdMPRYR4a3HFgP7ULGgs3wd9Ye4A==
X-Received: by 2002:aa7:9804:0:b029:1f1:5340:77c1 with SMTP id e4-20020aa798040000b02901f1534077c1mr26329965pfl.72.1617692705503;
        Tue, 06 Apr 2021 00:05:05 -0700 (PDT)
Received: from localhost ([144.130.156.129])
        by smtp.gmail.com with ESMTPSA id x7sm18114838pff.12.2021.04.06.00.05.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 00:05:05 -0700 (PDT)
Date:   Tue, 06 Apr 2021 17:04:59 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v6 16/48] KVM: PPC: Book3S 64: Move interrupt early
 register setup to KVM
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
References: <20210405011948.675354-1-npiggin@gmail.com>
        <20210405011948.675354-17-npiggin@gmail.com>
        <YGvlguoc6IjjwybE@thinks.paulus.ozlabs.org>
In-Reply-To: <YGvlguoc6IjjwybE@thinks.paulus.ozlabs.org>
MIME-Version: 1.0
Message-Id: <1617692548.qxsokwkl3x.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Paul Mackerras's message of April 6, 2021 2:37 pm:
> On Mon, Apr 05, 2021 at 11:19:16AM +1000, Nicholas Piggin wrote:
>> Like the earlier patch for hcalls, KVM interrupt entry requires a
>> different calling convention than the Linux interrupt handlers
>> set up. Move the code that converts from one to the other into KVM.
>=20
> I don't see where you do anything to enable the new KVM entry code to
> access the PACA_EXSLB area when handling DSegI and ISegI interrupts.
> Have I missed something, or are you not testing PR KVM at all?

We just got rid of PACA_EXSLB, commit ac7c5e9b08ac ("powerpc/64s:
Remove EXSLB interrupt save area").

Thanks,
Nick
