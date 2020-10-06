Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88D08285250
	for <lists+kvm-ppc@lfdr.de>; Tue,  6 Oct 2020 21:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbgJFTUq (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 6 Oct 2020 15:20:46 -0400
Received: from sonic307-3.consmr.mail.ne1.yahoo.com ([66.163.190.122]:46855
        "EHLO sonic307-3.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726981AbgJFTUq (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 6 Oct 2020 15:20:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1602012045; bh=aQBm+9Bca4ejs9ftzYnk89bfX4ekoPZ6NeQWeQKD++E=; h=Date:From:Reply-To:Subject:References:From:Subject; b=uhjdyputIVmV+XMQ/klGlLZIsv7CTIsQ5mv6w6IdBspGAtrsZSUaJ592KVOeBL8F7uTMjWFh/LTnf5OqX3UUxwsp5WghYXBDzU6yZRj7fkaeOBlyb88zfxao4pvYdBxN45pgbEWXqIrLrmDBJuTQqfUXWgKEhkRg5Jaa/qxfjh6kVl3BjF/W4TAHDjbVh75mhX3y2ylLkLVG4zaLUBTqxXw8Ril1j8xHwaSU065wK9dzTyz90FECdKEclftHvmCImzyj+VFNawm5Nr/2qQSXJx0WGaTrh+d54gQP3/13hF87vvJiYaXMaD/ZjTYDGy4vY98di3u1NBlHS7vqjLRDjg==
X-YMail-OSG: Zsfx.xAVM1nvYpxJ9rOr8gTTkjL6iZO8bHlBuq1Zt4U0jL8qek4j3lgqa0Iivrh
 XAvQsVpcWAcbU0IkkF.v6LXjSfUFp6pGjDUfBUNUUAungPEQ_38q7z50zV9pxVXG45jO9UXTUf3q
 6bRaVfIrJsQ0oxb2G.PBihubHAjNn8DZVZ9FlWRM4pfrW37xXs2ZzS7S8a6stijoZ32YQyh2uoFB
 9mylhfulFywFJQnm04n61rFwmELSWAzZwyEVGt4BCERWVUJrOcw.3ymJSWbvPsk6JkjpmGqIBokf
 wGsoyisxWO1UnGqAL42MGaMwmDxIe6zgRZkBMQYFoEly.Nkrydvq_axYIOrvr7RzQOgbBlChyK5J
 _P53JunZQqVa2kfwRs1u735YLxJ.S_FH2hwZXm9sdSgeg2wZ59De_qha2AnwL0DIySh0X4Ylqicg
 4gSnJYA4b3i2_YDfQD9zydg8I8kefVYW63nMvTlGcIqnt8svf8k75dYnJc4TFiWzIv3Pfj79mhAs
 MWCG63uZtERb50C7vjvgR9oyEkaiguLmKUZ_3XEZdfvZKJN4.jnQDlht99arZIwpMCfhzmP4vp2Y
 wVWSGBqsGteFiWXAnsLyi0zyVXy56ikhfc_EjebNcXBFp.kDjShJsp_AzHNpJwR0ywFDGsCp.lyE
 Zzmn.snkoQlonM1zPyUCOevK3mGymWN0YPmZy3FjgcgcByOu4LPRFCa_fN.lTP5SAigl1kItx70Q
 I6IkAineCXLVepi5ox3aUGoqiqvXp9hDNuC3O6RSIDdZGAOKf2H5zdovv4qPOdkBtCLAZuqhZMbW
 0tTZSb5HTZlL8TXHYEWWVy22JyWS45Ox__vNT3TvvnTPM_yql6vUdo1PiNRcCfY7uXVMSTcGjkF2
 uB4eCHd8_fycts3eUASDAR4SafNKCZDi5SkwfGgk6EaWnHbutb_5vL0ffhz7VPGqwV5cetqfn1du
 YUPPv_NkArhlopkPGUY1i8u02NuXmeahp51lp1b7164hANUdLXeJPwAWB9odcMcZRKk3yMKa5mtu
 9dXUZHjS2k9nD2cS3y2e9x4XkeIff.0Qih6QfiFTAMfb68LKw6saZycxPdTNoKTUKREXB1buazKs
 aAi_atdT.lzbDCH7Im7jqJER58w.loJMgJnV9B12HyFL01XaFrCqgEEayxwnPr3rt5GYpmj8qJrT
 I3lxT2befF6UF0e4.TWNJkuxtZarv.LYuMInqAdXKkL4ZmOIvBFMb3jqW.G30WujShcquirqsQu5
 2EmwVhg.WC6xkSCOZLO..xVUVXwGga7q6YCYy74trTqFkT3H2NapH8LmFlnXzvnv.WbF459xqeTT
 H_YxedsDTV328wTYMD12cxmC4WHOLuy0aLCtEwCSCiqRTkRkmr3Ycx_3YemwpLFE4YHsU8hlELmV
 s9ahzTBQ9Z3QgfqmxJ5rDzejv4ADStKr1Rib0ucASHDjkEqLEGxKuIzDGJBhcDUUMWduiufVvNp6
 RHMjCQYBgNw--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.ne1.yahoo.com with HTTP; Tue, 6 Oct 2020 19:20:45 +0000
Date:   Tue, 6 Oct 2020 19:18:44 +0000 (UTC)
From:   "Mrs. Maureen Hinckley" <mau8@lfsh.space>
Reply-To: maurhinck5@gmail.com
Message-ID: <751448603.2688949.1602011924739@mail.yahoo.com>
Subject: RE
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <751448603.2688949.1602011924739.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16718 YMailNodin Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.135 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



I am Maureen Hinckley and my foundation is donating (Five hundred and fifty=
 thousand USD) to you. Contact us via my email at (maurhinck5@gmail.com) fo=
r further details.

Best Regards,
Mrs. Maureen Hinckley,
Copyright =C2=A92020 The Maureen Hinckley Foundation All Rights Reserved.
