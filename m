Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65A1AE028B
	for <lists+kvm-ppc@lfdr.de>; Tue, 22 Oct 2019 13:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731902AbfJVLMO (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 22 Oct 2019 07:12:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54756 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731899AbfJVLMO (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Tue, 22 Oct 2019 07:12:14 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 08CCD859FF
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Oct 2019 11:12:14 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id e25so8392620wra.9
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Oct 2019 04:12:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E2ZDL5MWE9Y90XTWLGswK0j9jGkUeLSj3bLCyP33D0Q=;
        b=ANiy45vONhY0nmHz5XPNJQU7b3GcLbTAe088J4XlakhcQEhLDjFA6aMv7cNIUyYmcz
         1phgj1xnlA2U0X7TPiL+biyPsWgjLGWK98JV7ZrOTB0+NnNyW2KoG3R9/9U+j4Kimml9
         GIF2Ek6nN6IVdY4GVQcVS2YSmYt4stp5jatU4YSEhZDFdjgOFPI83/446q7GPt1POWMY
         KscQSfighNc4eop5xLbZsZj9HDgJEWB30GuwuarfoFroWofAKueHYqhACHwQ7BaBzY/u
         EMbyhwEWwGdRUHNO0BJ/jp+CI+vNMuJLXypXLqAYzXwPBrpGgSXYiSH5dy0AoROx/DTc
         QBoQ==
X-Gm-Message-State: APjAAAVpu5yuH/swPZR93GWAzDCgdIhlUilezN2S2vmQrRhQ+uVF1rZ9
        rcgXOmdijSNowuHvYJ9Tnvd77XpigyG9H7WA/TlbmjQfqM6mI5d3S/D0juVnv+NrR+9aGvm2p/E
        2vCCIZVwb/IdrVYveWg==
X-Received: by 2002:a5d:4a82:: with SMTP id o2mr2963066wrq.186.1571742732656;
        Tue, 22 Oct 2019 04:12:12 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzQSbg8nAWiZug0SQHMFaSialsyHY/264PzMng3CXcdBC7yG28gelCmJEgWfPnOeawwuhJb2w==
X-Received: by 2002:a5d:4a82:: with SMTP id o2mr2963038wrq.186.1571742732282;
        Tue, 22 Oct 2019 04:12:12 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c0e4:dcf4:b543:ce19? ([2001:b07:6468:f312:c0e4:dcf4:b543:ce19])
        by smtp.gmail.com with ESMTPSA id g10sm3434511wrr.28.2019.10.22.04.12.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Oct 2019 04:12:11 -0700 (PDT)
Subject: Re: [GIT PULL] Please pull my kvm-ppc-fixes-5.4-1 tag
To:     Paul Mackerras <paulus@ozlabs.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
References: <20191021041941.GA17498@oak.ozlabs.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <03cfcf50-7802-56f2-0915-0d890f5d8e75@redhat.com>
Date:   Tue, 22 Oct 2019 13:12:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191021041941.GA17498@oak.ozlabs.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 21/10/19 06:19, Paul Mackerras wrote:
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc tags/kvm-ppc-fixes-5.4-1

Pulled, thanks.

Paolo
