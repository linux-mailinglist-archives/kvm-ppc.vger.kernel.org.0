Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EEE42792EF
	for <lists+kvm-ppc@lfdr.de>; Fri, 25 Sep 2020 23:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728171AbgIYVGV (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 25 Sep 2020 17:06:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60620 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726064AbgIYVGS (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 25 Sep 2020 17:06:18 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601067977;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Nph2D9IVfI+xvuD8zFp+f/GwIX9O4qj0XvwXCm0EYyg=;
        b=F12R0nHSdMK31s3AUSmxrufvxo58xMgoFF/2SFzXC+xgZnC2lR1lEYQbMJ/O/+4SZSksnm
        cfYEUIhiHZ2laP5FZu73cdDggRwCNkHVP11iNsiGCDXLbEROsuoomJLLN+QjEp7U0o7rzl
        ytwjZZres2mjoLn2ogo6XWoaYPxLwgU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-559-7m7hoK5COcmkLZWaTiiNJw-1; Fri, 25 Sep 2020 17:06:13 -0400
X-MC-Unique: 7m7hoK5COcmkLZWaTiiNJw-1
Received: by mail-wr1-f71.google.com with SMTP id 33so1548729wrk.12
        for <kvm-ppc@vger.kernel.org>; Fri, 25 Sep 2020 14:06:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Nph2D9IVfI+xvuD8zFp+f/GwIX9O4qj0XvwXCm0EYyg=;
        b=tfvUd2mqbO/J4AKiDX5eJ/jMlykKecUP7La0vR37czZUPsLkzUZz98GGzck7Kbm9L+
         1yx7QJwUrYzBX2llxa9YRnG4bkrFaWNCtcAR3LWuA6QnqODKQvJ9fDRd+ezLF51f8tZx
         6C0gbpKTbTKh+711JL8Wp+XciiofJDx2a/JS3kpo7e0Tk/l77AkFVfORwpbphIMHruSc
         gIAuu1gLWO01piX4YdOikmsG1Q78z0eSqa9O6h4rHK/64LYBImT3WJMvVdysM0DJ2zv2
         I69Sby3sT29lihD2QpvOaEvOnPshThkXICbCEfVA7ZuoPwweCJYL8C311vuFnBVaY6rE
         Rmbg==
X-Gm-Message-State: AOAM532N9+DZQ9oB9NQWbWIO7Z+hYW80Ar0FT/bd9rPENphZ+xhAzFd/
        qKRLYLewQ+VL5o3FHRptK8TMUW9gkHieSoATIvzTMj+09W8UNaHEkSWR51+ITyWSa3AlSBPeJwz
        s0k+XXZ/StloxRFV/tg==
X-Received: by 2002:adf:f207:: with SMTP id p7mr6889814wro.152.1601067972440;
        Fri, 25 Sep 2020 14:06:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw+svzQTyn/sr+1A0KnMYOANfhe1Lyv2OpG+lPc9M4qsZez3YRF08veAZn1ubvdVOTuIczmeg==
X-Received: by 2002:adf:f207:: with SMTP id p7mr6889795wro.152.1601067972235;
        Fri, 25 Sep 2020 14:06:12 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec9b:111a:97e3:4baf? ([2001:b07:6468:f312:ec9b:111a:97e3:4baf])
        by smtp.gmail.com with ESMTPSA id t203sm255701wmg.43.2020.09.25.14.06.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 14:06:11 -0700 (PDT)
Subject: Re: [RFC PATCH 3/3] KVM: x86: Use KVM_BUG/KVM_BUG_ON to handle bugs
 that are fatal to the VM
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Huacai Chen <chenhc@lemote.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        linux-mips@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        kvm-ppc@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
References: <20200923224530.17735-1-sean.j.christopherson@intel.com>
 <20200923224530.17735-4-sean.j.christopherson@intel.com>
 <878scze4l5.fsf@vitty.brq.redhat.com> <20200924181134.GB9649@linux.intel.com>
 <87k0wichht.fsf@vitty.brq.redhat.com>
 <20200925171233.GC31528@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <731dd323-8c66-77ff-cf15-4bbdea34bcf9@redhat.com>
Date:   Fri, 25 Sep 2020 23:06:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200925171233.GC31528@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 25/09/20 19:12, Sean Christopherson wrote:
>> Do we actually want to prevent *all* ioctls? E.g. when 'vm bugged'
>> condition is triggered userspace may want to extract some information to
>> assist debugging but even things like KVM_GET_[S]REGS will just return
>> -EIO. I'm not sure it is generally safe to enable *everything* (except
>> for KVM_RUN which should definitely be forbidden) so maybe your approach
>> is preferable.
>
> The answer to this probably depends on the answer to the first question of
> when it's appropriate to use KVM_BUG().  E.g. if we limit usage to fatal or
> dangrous cases, then blocking all ioctls() is probably the right thing do do.

I think usage should be limited to dangerous cases, basically WARN_ON
level.  However I agree with Vitaly that KVM_GET_* should be allowed.

The other question is whether to return -EIO or KVM_EXIT_INTERNAL_ERROR.
 The latter is more likely to be handled already by userspace.

Paolo

