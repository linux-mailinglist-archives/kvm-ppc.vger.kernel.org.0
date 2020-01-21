Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05088144035
	for <lists+kvm-ppc@lfdr.de>; Tue, 21 Jan 2020 16:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729052AbgAUPKp (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 21 Jan 2020 10:10:45 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25205 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727255AbgAUPKo (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 21 Jan 2020 10:10:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579619444;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dLNqv137Ty3zBX/5Bsp+2Ypr44jpbB2i9ogizbwLSF8=;
        b=D+3rhBDokrgj8pSQCX3LLld74t04jHdPgp1dCzOanI/juk3cBEseM0Osp41+2eyZgqyatn
        Uf+A4Rkw80Nhm5U3+IJTYnEinfk2MbQHtbGIAMNOsTIV6S8Yskq2Nsn3dRVpmYzST2TqBD
        CUhRHnK9EAsMWQVo19+F+Kn9YPX0p+0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-LjybKeqqP12aku9kW8EsUQ-1; Tue, 21 Jan 2020 10:10:33 -0500
X-MC-Unique: LjybKeqqP12aku9kW8EsUQ-1
Received: by mail-wm1-f72.google.com with SMTP id t16so734139wmt.4
        for <kvm-ppc@vger.kernel.org>; Tue, 21 Jan 2020 07:10:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dLNqv137Ty3zBX/5Bsp+2Ypr44jpbB2i9ogizbwLSF8=;
        b=EtCx4l+b3shK6hhp6IGgqNrBIHQdmapEG80108l5+tg8X6faPRaVMP+IlhsXxY6AW5
         8qHIWuEwIj9OaJwvdnRfWunmmlufYSttJsGIbLO4CSTOXtV5ziouRcYkRG7gVs9p4VcX
         s5IlhyLvX3mUZVxOjbV2ZRHy6ALWpvc70cbBnjOD33L+nvnp8brcQqjwnADUBnkORGPV
         kEcpnIx3QZVSUIFFZvWw9pB3Amuue9nIDXYE89Y0Sb5emEz/limO5vEmv7/V3QWaDmbJ
         yUmMG2JEVE3Nb/AhULRx1YmTk1FfADUjsUFX95ZiWWB6p9fQLAp9NLpTRpkiquyX0ADW
         tymw==
X-Gm-Message-State: APjAAAU0uiriPzKHwZyf+3bse4PHLMug6JqxNWG27UQjqzpqkck6tpOI
        J0c89obwEfT9YtqUsqpAPFobvQLgpDCmnDVBnrqjaNaC9UgRRp3QfXMdpBixDfi8BVL8Rnhzf55
        yeYZIgjOUnCO/tLz4qQ==
X-Received: by 2002:a5d:484d:: with SMTP id n13mr5658192wrs.420.1579619431917;
        Tue, 21 Jan 2020 07:10:31 -0800 (PST)
X-Google-Smtp-Source: APXvYqxxEyxfwVY/ROHiQo6nFEJMG0NaKySaBG+B/YnTEdUCo5yvn8VFW7mI2ukJg01QncMPDMI9zQ==
X-Received: by 2002:a5d:484d:: with SMTP id n13mr5658133wrs.420.1579619431579;
        Tue, 21 Jan 2020 07:10:31 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b509:fc01:ee8a:ca8a? ([2001:b07:6468:f312:b509:fc01:ee8a:ca8a])
        by smtp.gmail.com with ESMTPSA id h2sm53828069wrv.66.2020.01.21.07.10.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 07:10:31 -0800 (PST)
Subject: Re: [PATCH 00/14] KVM: x86/mmu: Huge page fixes, cleanup, and DAX
To:     Barret Rhoden <brho@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        syzbot+c9d1fb51ac9d0d10c39d@syzkaller.appspotmail.com,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        David Hildenbrand <david@redhat.com>,
        Jason Zeng <jason.zeng@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        linux-nvdimm <linux-nvdimm@lists.01.org>
References: <20200108202448.9669-1-sean.j.christopherson@intel.com>
 <e3e12d17-32e4-84ad-94da-91095d999238@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d7d0801b-79be-a5e7-a376-abd92b5c09b2@redhat.com>
Date:   Tue, 21 Jan 2020 16:10:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <e3e12d17-32e4-84ad-94da-91095d999238@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 09/01/20 20:47, Barret Rhoden wrote:
> Hi -
> 
> On 1/8/20 3:24 PM, Sean Christopherson wrote:
>> This series is a mix of bug fixes, cleanup and new support in KVM's
>> handling of huge pages.  The series initially stemmed from a syzkaller
>> bug report[1], which is fixed by patch 02, "mm: thp: KVM: Explicitly
>> check for THP when populating secondary MMU".
>>
>> While investigating options for fixing the syzkaller bug, I realized KVM
>> could reuse the approach from Barret's series to enable huge pages for
>> DAX
>> mappings in KVM[2] for all types of huge mappings, i.e. walk the host
>> page
>> tables instead of querying metadata (patches 05 - 09).
> 
> Thanks, Sean.  I tested this patch series out, and it works for me.
> (Huge KVM mappings of a DAX file, etc.).

Queued, thanks.

Paolo

