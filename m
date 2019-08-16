Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 119E8907B4
	for <lists+kvm-ppc@lfdr.de>; Fri, 16 Aug 2019 20:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727542AbfHPSZR (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 16 Aug 2019 14:25:17 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:40385 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727451AbfHPSZR (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 16 Aug 2019 14:25:17 -0400
Received: by mail-io1-f66.google.com with SMTP id t6so8059567ios.7
        for <kvm-ppc@vger.kernel.org>; Fri, 16 Aug 2019 11:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F3S+OzCu1yWNtyjcTHvpsq8kAfwz2WK26QR/yvCAhDU=;
        b=IN9VuSV7Ibz7E3uVf36DPoeJdSpkGxFHLj6dYNXmXyvQUe4qrojb6pxghaMlkgzjjW
         fnLDH3LqQ/rIcKzF+XvRbXESIepDNxB0cACcWUEPUQrFp/mKpC4tAvvDNkDxQhKvZLAv
         DAH75Tga2mmL1lUplWY5DATKzyAhP35VRFzMLyLQQiSEDtmaM2PNRNtsQObBmj2X1jyM
         OqOQzpQlHmCFChzBmZfGVp14m6nq/gwXheIIWaCvNIrK5qsq8wleodU9gr3l8yGtCweJ
         Ovi03mGWOzfTMuSzyYAAq9bZRLCKKTeVZHcv13F64CzQqKly7IjGma4x+S84NYwpq6ML
         4ePQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F3S+OzCu1yWNtyjcTHvpsq8kAfwz2WK26QR/yvCAhDU=;
        b=kIDR6fLM2/Eg2wNZaJDed2uK5eKkykJin/C/2F/yJHz8bAc2Pr52EYJwfdzJmRRHff
         4XN2lvXW+Q3zJPdO1yazIZTHHhwAWoO57DoZbYIqzhhuZh7SIFiwN6odXze37CgO+npO
         oLOVaognAJGiXeqfPUlE6ywWJOto0Mj8dx/AqzWECiePtVBvbfKQhAmt3HV4wi8hfRpZ
         WptKN96KC6rW8v3FY4gEu0vi8dhpJJ32PRqrellnzE4r8GdegKsb5SXXU+WAvjIH2NE2
         s5emuwBIby0m6z5GWQR8VJfxxgbQYgE450xtOQxTSY/hQWuAwOL8owwqO6f/+l1o1/V/
         F+3Q==
X-Gm-Message-State: APjAAAWpXQRGDE2II6qjffFH7baU2bEddQBIZFq2go8rqeLGeCH7afjI
        0mT2eWVRCth0a58bCRv6CkfS6wvrcXT8oGqaZo6Ecw==
X-Google-Smtp-Source: APXvYqy/pQ68ktJraZx2OOVpVJ8kHPldt0Y3rCKUg8hxUR6Vc+ePWJRCAjjILHp6RQ68WRLW89S+fyHYBIDZKbwX06U=
X-Received: by 2002:a02:a405:: with SMTP id c5mr12489114jal.54.1565979916097;
 Fri, 16 Aug 2019 11:25:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190815172237.10464-1-sean.j.christopherson@intel.com>
In-Reply-To: <20190815172237.10464-1-sean.j.christopherson@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 16 Aug 2019 11:25:05 -0700
Message-ID: <CALMp9eQZ=c4nkKmJQr4omdCmB=P1Yug+g_XK_fqZ0YZuEt0Pkg@mail.gmail.com>
Subject: Re: [PATCH] KVM: Assert that struct kvm_vcpu is always as offset zero
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>, Joerg Roedel <joro@8bytes.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm-ppc@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Aug 15, 2019 at 10:23 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> KVM implementations that wrap struct kvm_vcpu with a vendor specific
> struct, e.g. struct vcpu_vmx, must place the vcpu member at offset 0,
> otherwise the usercopy region intended to encompass struct kvm_vcpu_arch
> will instead overlap random chunks of the vendor specific struct.
> E.g. padding a large number of bytes before struct kvm_vcpu triggers
> a usercopy warn when running with CONFIG_HARDENED_USERCOPY=y.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
X86 parts:
Reviewed-by: Jim Mattson <jmattson@google.com>
