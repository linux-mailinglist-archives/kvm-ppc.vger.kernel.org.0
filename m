Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 579301441D6
	for <lists+kvm-ppc@lfdr.de>; Tue, 21 Jan 2020 17:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729276AbgAUQPp (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 21 Jan 2020 11:15:45 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55213 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729275AbgAUQPp (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 21 Jan 2020 11:15:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579623344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AEkduNyC81KhwQJxdqWed6PQvDBDr5ym7z5qlXYD16Q=;
        b=QJN+uAS5MH/EtWGeX+YSz+CqZLf9xaz69S2bhn3AQMMCRWKLhJDyeMGsrU1FyoPMB5m/v7
        62lQt7dA1I8fqFfBoG7iFjILk0Z/vPIPSimRBPZGZbnc/jB7VYYsBPFmACMnSA675UERVU
        N0Qy0J9v5cWWulfNhnfF9WqaI+U4XWo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-HB2ZVFIKOueP2aBxkAoRug-1; Tue, 21 Jan 2020 11:15:42 -0500
X-MC-Unique: HB2ZVFIKOueP2aBxkAoRug-1
Received: by mail-wr1-f72.google.com with SMTP id u12so1520460wrt.15
        for <kvm-ppc@vger.kernel.org>; Tue, 21 Jan 2020 08:15:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AEkduNyC81KhwQJxdqWed6PQvDBDr5ym7z5qlXYD16Q=;
        b=W+WB5Nf8Ii6pBiRLujolRecheL+v/SvB8mrUMUKNkrWshxp5awAliL8hgYN1w7qvuy
         ggxwcOqd7bcNYGXxq35Yq8pC/uTU8eyfnDl37zdB6Oiw4QcnUDHpTvj2Opw+rBj66Sgq
         XVIAU2LB6u1I1B9g06COEozCaVrCfDxoBgyoV5O+wfNKQSudSKxDaYzINpywq7Ynh5CD
         GGeWISsiBVhcEaRhWIJHcdE3NfNubCbfLw38n3pM1cxwKLuK4p09A+h7xfVvJl6XVV+B
         7X6G4w2Lfx4adEPKDn2mHTQHjBp5zHvv7vPX/yWH3p2QiCtodDo4LC8gHDT3xWjN8gLq
         9nIA==
X-Gm-Message-State: APjAAAXItmb6sLJn1tfZJfHv+rcTZ+AAw/zT0QUXqloBHRathNj73p/D
        d1whIpz6ZRd3gQV62LaQny66huFjZ6Crgl5/O5tqG4RjM97RQA9l5d6BXWh3eXuAcHJeiEQRxbx
        SvH1Ba7jubQS4gjQVhA==
X-Received: by 2002:adf:fe12:: with SMTP id n18mr6445951wrr.158.1579623341133;
        Tue, 21 Jan 2020 08:15:41 -0800 (PST)
X-Google-Smtp-Source: APXvYqzgy0miniVe2Gl4AtVIKyRZ4+vdymNAkzRDe+HsI+a509q2/6E0NlYBf/qPrHLrk+8Cx1rdIw==
X-Received: by 2002:adf:fe12:: with SMTP id n18mr6445931wrr.158.1579623340791;
        Tue, 21 Jan 2020 08:15:40 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b509:fc01:ee8a:ca8a? ([2001:b07:6468:f312:b509:fc01:ee8a:ca8a])
        by smtp.gmail.com with ESMTPSA id s3sm4451273wmh.25.2020.01.21.08.15.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 08:15:40 -0800 (PST)
Subject: Re: [GIT PULL] Please pull my kvm-ppc-next-5.6-1 tag
To:     Paul Mackerras <paulus@ozlabs.org>, kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm-ppc@vger.kernel.org
References: <20200121033326.GA23311@blackberry>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <eb21326a-66bc-c75a-13b6-bd4178afabe0@redhat.com>
Date:   Tue, 21 Jan 2020 17:15:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200121033326.GA23311@blackberry>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 21/01/20 04:33, Paul Mackerras wrote:
> Paolo,
> 
> Please do a pull from my kvm-ppc-next-5.6-1 tag to get a PPC KVM
> update for 5.6.
> 
> Thanks,
> Paul.
> 
> The following changes since commit c79f46a282390e0f5b306007bf7b11a46d529538:
> 
>   Linux 5.5-rc5 (2020-01-05 14:23:27 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc tags/kvm-ppc-next-5.6-1
> 
> for you to fetch changes up to 3a43970d55e9fd5475d3c4e5fe398ab831ec6c3a:
> 
>   KVM: PPC: Book3S HV: Implement H_SVM_INIT_ABORT hcall (2020-01-17 15:08:31 +1100)

This may take a couple days because I am running a lot of tests on a
very scary x86 5.6 update, but I have already pulled it locally.

Paolo

> ----------------------------------------------------------------
> KVM PPC update for 5.6
> 
> * Add a hypercall to be used by the ultravisor when secure VM
>   initialization fails.
> 
> * Minor code cleanups.
> 
> ----------------------------------------------------------------
> Leonardo Bras (2):
>       KVM: PPC: Book3S: Replace current->mm by kvm->mm
>       KVM: PPC: Book3E: Replace current->mm by kvm->mm
> 
> Sukadev Bhattiprolu (2):
>       KVM: PPC: Add skip_page_out parameter to uvmem functions
>       KVM: PPC: Book3S HV: Implement H_SVM_INIT_ABORT hcall
> 
> zhengbin (1):
>       KVM: PPC: Remove set but not used variable 'ra', 'rs', 'rt'
> 
>  Documentation/powerpc/ultravisor.rst        | 60 +++++++++++++++++++++++++++++
>  arch/powerpc/include/asm/hvcall.h           |  1 +
>  arch/powerpc/include/asm/kvm_book3s_uvmem.h | 10 ++++-
>  arch/powerpc/include/asm/kvm_host.h         |  1 +
>  arch/powerpc/kvm/book3s_64_mmu_hv.c         |  4 +-
>  arch/powerpc/kvm/book3s_64_mmu_radix.c      |  2 +-
>  arch/powerpc/kvm/book3s_64_vio.c            | 10 +++--
>  arch/powerpc/kvm/book3s_hv.c                | 15 +++++---
>  arch/powerpc/kvm/book3s_hv_uvmem.c          | 32 ++++++++++++++-
>  arch/powerpc/kvm/booke.c                    |  2 +-
>  arch/powerpc/kvm/emulate_loadstore.c        |  5 ---
>  11 files changed, 119 insertions(+), 23 deletions(-)
> 

