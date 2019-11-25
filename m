Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1485F108BA9
	for <lists+kvm-ppc@lfdr.de>; Mon, 25 Nov 2019 11:29:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727399AbfKYK3n (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 25 Nov 2019 05:29:43 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:34325 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725828AbfKYK3n (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 25 Nov 2019 05:29:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574677781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=DMX+4DjoA/HeaRN7qAer+GRB8f0jc/420ZRTLAZw6fQ=;
        b=ClZczNV7KOM2U2lzqjp+h++zKuN5ugvaJL8tNLJO9XyPswkvegJ0SeJsx9rBnTS12JFHlq
        iQui6LJiPOhAZF1BIF8jSDwjoFbCNJNnlDQIw8SIgUp4utNpM28RH6E4whaWqucitQ32ln
        k8kuO6Ihiq03sz7SdWSbzDXsDrojA6w=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-262-QaGH8s8XPUqi8o-z9-Mnhw-1; Mon, 25 Nov 2019 05:29:38 -0500
Received: by mail-wm1-f69.google.com with SMTP id 199so6406128wmb.0
        for <kvm-ppc@vger.kernel.org>; Mon, 25 Nov 2019 02:29:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nzKy0BDo0TyBU4g7o2ffXKqI/Ei69F9XOzZU0Y5BBLQ=;
        b=lUtaf9L090A/IftI8r/aLfvmgywWV6hcSyTFAou3KY1Ilsso+WJBDxGucQV5uPkHfB
         JAE26tQW7g+Z/RjCSvf7HqT7rMAvAGQnxQvmfmoZnUXnkQYkIHcx3HNJWVsqvc2fQBtF
         Ic6VuahWTWuIgQsaUjtl7F95Lko3zucNqLOhUJ/Ue6nOXsDGs4hcFj5mt+bNU6Bycop9
         IXSn0p7KsH6j+eMOPrMyq40yFy36yiJgyIqYLnd9Cf2W+YcQQ8lP8HGuT41VrUhrpSx7
         yLyWFktsORL9tSuHlEwc+yFPh5CWHLbtGx9aT2Golp4V+WPGC6jIabqOof1xB4hF2Jec
         Xnlg==
X-Gm-Message-State: APjAAAUkTvq1XKAhSc3kq3Vk7WKOCBtAGytyOEywZ4RQBu4erWfeGKRK
        AB71O6DxCzoGDnFuIQ3jw0A6SJuXXZglbtzyLzWMtdbMU+8L0O773z5BVUZ+evCxFRWHTWPJd/6
        1LJNdIHM8FDQkQQAecQ==
X-Received: by 2002:a1c:20c6:: with SMTP id g189mr14762779wmg.6.1574677777306;
        Mon, 25 Nov 2019 02:29:37 -0800 (PST)
X-Google-Smtp-Source: APXvYqwwhMeeOtg8TNe50FFjcVTwaf4a/llhmoMUoDQqAulZUKJiWuX5XpjgyQySM3zdZ1flOnc+IQ==
X-Received: by 2002:a1c:20c6:: with SMTP id g189mr14762758wmg.6.1574677777016;
        Mon, 25 Nov 2019 02:29:37 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5454:a592:5a0a:75c? ([2001:b07:6468:f312:5454:a592:5a0a:75c])
        by smtp.gmail.com with ESMTPSA id b15sm9691730wrx.77.2019.11.25.02.29.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Nov 2019 02:29:36 -0800 (PST)
Subject: Re: [GIT PULL] Please pull my kvm-ppc-next-5.5-2 tag
To:     Paul Mackerras <paulus@ozlabs.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org, Greg Kurz <groug@kaod.org>
References: <20191125005826.GA25463@oak.ozlabs.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <eff48bca-3ef0-8ae4-79d4-5e8087bded1a@redhat.com>
Date:   Mon, 25 Nov 2019 11:29:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191125005826.GA25463@oak.ozlabs.ibm.com>
Content-Language: en-US
X-MC-Unique: QaGH8s8XPUqi8o-z9-Mnhw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 25/11/19 01:58, Paul Mackerras wrote:
> Paolo,
>=20
> Please do a pull from my kvm-ppc-next-5.5-2 tag to get two more
> commits which should go upstream for 5.5.  Although they are in my
> kvm-ppc-next branch, they are actually bug fixes, fixing host memory
> leaks in the XIVE interrupt controller code, so they should be fine to
> go into v5.5 even though the merge window is now open.
>=20
> Thanks,
> Paul.

Yes, of course (I have even accepted submaintainer pull request for new
features during the first week of the merge window, so not a problem at
all).

I'll send my pull request to Linus shortly.

Paolo

