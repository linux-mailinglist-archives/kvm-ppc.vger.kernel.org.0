Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 224FF19EF09
	for <lists+kvm-ppc@lfdr.de>; Mon,  6 Apr 2020 03:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbgDFBPG (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 5 Apr 2020 21:15:06 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:34182 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726408AbgDFBPG (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 5 Apr 2020 21:15:06 -0400
Received: by mail-il1-f194.google.com with SMTP id t11so13154972ils.1;
        Sun, 05 Apr 2020 18:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IbprTDW1u1HJSZmzEjh4jO7mD74iEgUk0lP0fkv1P5U=;
        b=GkHHIbyOBZRFRpN+beehXEmD1sX8a7TvGoNIJPqJz4BdB4IxJwMEqZNFt9lt95Lewc
         k+kP9/qc/H0akb0VM1N/pFTzJKtGebCHlxGPab+9fUPwdJvzppoM5MD0BNdxER2KONJS
         Ps7ZsmbYXpeaf1qVmQ2b8ekmdbTzyuTTeUdQom+Nvup2XVthSRbyduMQeu1D50/mRkNo
         2YfVErRZ/7MIPh8OmQIroRxNG9Fb51uDv5ThBw43Uz7huaG0zRLbtnQOo2Xvt4yIZiOH
         r8NR59/akimA+OXb+cO8cHFTn4rT4Ew9CEIvsDqDbJFfuaLL1rxYWSRF/Ok6F28H+Kti
         JABg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IbprTDW1u1HJSZmzEjh4jO7mD74iEgUk0lP0fkv1P5U=;
        b=CqN1I6ggk8NqTC7ZhmTRPwLYSE9D7b/orKgWCeoJPsOM/qG+nMwnoxWT4IBJ/PeXug
         r+6OyqBIjdhGqAFrfp9kqZceJZI9sZBOotD0EuuUxNOWsm0qgKpKn1OOSuO1+iLSjaeM
         0TXFPJ6qC6NEcvranOtDhCCPBUeH0418imGJOB6BQNL/hEh5k6oSvfnV52602TrazYQl
         NnSsUVe+6UNgzag94wgV5dbjilRqycEmPf0voNHn46rW3tdERvcSZXcUeatDJYXa6Mo7
         U8DCx2eHsIv3CkQISelI9ZPbPJUlOFRgTy1dJ7SP6l+owB3GlE6nZR09dzVxWxdM8tEF
         MlsA==
X-Gm-Message-State: AGi0PuZqdgLZ14g/10LLPNICw5z3BpTQ9BMFw6oLx4ZNi30cdk6/cEm1
        RWrVO1bVhmllYdj/j2a2bHTzEDtN3MMs9YVM/0k=
X-Google-Smtp-Source: APiQypKmuujWglLFGvt6mgZTt0c2Lfo3xvnJLGSPMnshz82WbFzycEx19jZVaLgsryxjZKYQCznynOkynrPgvYkFPSs=
X-Received: by 2002:a92:5b56:: with SMTP id p83mr19231598ilb.70.1586135705788;
 Sun, 05 Apr 2020 18:15:05 -0700 (PDT)
MIME-Version: 1.0
References: <a2e4aca0-8e3a-2496-b9a3-ccacf41fd3d9@web.de>
In-Reply-To: <a2e4aca0-8e3a-2496-b9a3-ccacf41fd3d9@web.de>
From:   Qiujun Huang <hqjagain@gmail.com>
Date:   Mon, 6 Apr 2020 09:14:52 +0800
Message-ID: <CAJRQjod7jVRrAEmk1=qgVf5RH5oedmLC4n7Ujsh-G7sosesGDw@mail.gmail.com>
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Remove NULL check before kfree
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Chen Zhou <chenzhou10@huawei.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Sorry about noise, please just ignore it.

On Mon, Apr 6, 2020 at 4:50 AM Markus Elfring <Markus.Elfring@web.de> wrote:
>
> > NULL check before kfree is unnecessary, so remove it.
>
> Would you like to take similar update suggestions into account?
> * 2019-09-04
>   KVM: PPC: Book3S HV: Delete an unnecessary check before kfree() in __kvmhv_nested_page_fault()
>
> * [-next] KVM: PPC: Book3S HV: remove redundant NULL check
>   https://lkml.kernel.org/lkml/20200401130903.6576-1-chenzhou10@huawei.com/
>   https://lore.kernel.org/patchwork/patch/1218800/
>
> Regards,
> Markus
